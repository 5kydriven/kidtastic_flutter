#!/usr/bin/env node

/**
 * analyze-patterns command implementation
 * 
 * Analyzes codebase for recurring patterns, similar implementations, and refactoring opportunities.
 * 
 * Usage: /analyze-patterns [--pattern=<pattern>] [--language=<lang>] [--depth=<level>] [--output=<format>]
 */

const { execSync } = require('child_process');
const fs = require('fs');
const path = require('path');

// Predefined patterns for different languages
const PREDEFINED_PATTERNS = {
  // Dart/Flutter patterns
  dart: {
    'repository': {
      regex: /class\s+\w+Repository\s*\{/g,
      description: 'Repository pattern implementation',
      example: 'class StudentRepository { ... }'
    },
    'bloc': {
      regex: /class\s+\w+Bloc\s+extends\s+Bloc</g,
      description: 'BLoC pattern implementation',
      example: 'class StudentProfileBloc extends Bloc<...> { ... }'
    },
    'freezed-model': {
      regex: /@freezed[\s\S]*?class\s+\w+\s+with\s+_\$\w+/g,
      description: 'Freezed immutable model',
      example: '@freezed class Student with _$Student { ... }'
    },
    'dao': {
      regex: /@DriftAccessor[\s\S]*?class\s+\w+Dao\s+extends\s+DatabaseAccessor/g,
      description: 'Drift DAO pattern',
      example: '@DriftAccessor class StudentDao extends DatabaseAccessor { ... }'
    },
    'error-handling': {
      regex: /try\s*\{[\s\S]*?\}\s*catch\s*\([^)]*\)\s*\{[\s\S]*?return\s+Result\s*\(\s*statusCode:\s*\d+\s*\)/g,
      description: 'Try-catch with Result pattern',
      example: 'try { ... } catch (e) { return Result(statusCode: 400); }'
    },
    'singleton': {
      regex: /static\s+(?:final|const)\s+\w+\s+_instance[\s\S]*?factory\s+\w+\s*\(\s*\)/g,
      description: 'Singleton pattern',
      example: 'static final _instance = ... factory() => _instance;'
    },
    'table-definition': {
      regex: /class\s+\w+Table\s+extends\s+Table\s*\{/g,
      description: 'Drift table definition',
      example: 'class StudentTable extends Table { ... }'
    },
    'result-pattern': {
      regex: /return\s+Result\s*\(\s*(?:data:[\s\S]*?)?statusCode:\s*\d+/g,
      description: 'Result pattern return statement',
      example: 'return Result(statusCode: 200, data: ...);'
    }
  },
  
  // JavaScript/TypeScript patterns
  js: {
    'singleton': {
      regex: /(?:getInstance|getInstance\s*\(\s*\)|new\s+\w+\s*\(\s*\)|Object\.create|Object\.freeze)/g,
      description: 'Singleton pattern',
      example: 'getInstance() { ... }'
    },
    'factory': {
      regex: /(?:create|factory|make|build)\s*\([^)]*\)\s*\{/g,
      description: 'Factory pattern',
      example: 'create(config) { ... }'
    },
    'observer': {
      regex: /(?:addEventListener|on\w+|emit|subscribe|observer)/gi,
      description: 'Observer/event pattern',
      example: 'addEventListener("click", ...)'
    },
    'error-handling': {
      regex: /try\s*\{[\s\S]*?\}\s*catch\s*\([^)]*\)/g,
      description: 'Error handling pattern',
      example: 'try { ... } catch (err) { ... }'
    },
    'async-patterns': {
      regex: /(?:async|await|Promise|\.then|\.catch)/g,
      description: 'Async/await or Promise pattern',
      example: 'async function() { await ... }'
    },
    'api-endpoint': {
      regex: /(?:app\.(?:get|post|put|delete|patch)|router\.(?:get|post|put|delete|patch)|export\s+(?:async\s+)?function\s+(?:GET|POST|PUT|DELETE|PATCH))/gi,
      description: 'API endpoint definition',
      example: 'app.post("/api/users", ...)'
    },
    'middleware': {
      regex: /(?:middleware|app\.use|router\.use)/gi,
      description: 'Middleware implementation',
      example: 'app.use(middleware)'
    }
  },
  
  // Python patterns
  py: {
    'decorator': {
      regex: /@\w+\s*(?:\([^)]*\))?\s*\n\s*def\s+/g,
      description: 'Decorator pattern',
      example: '@decorator\ndef func(): ...'
    },
    'context-manager': {
      regex: /(?:with\s+\w+\s*\(|__enter__|__exit__)/g,
      description: 'Context manager pattern',
      example: 'with open(file) as f: ...'
    },
    'error-handling': {
      regex: /try\s*:[\s\S]*?except\s+\w+/g,
      description: 'Exception handling pattern',
      example: 'try: ... except Exception: ...'
    },
    'async-patterns': {
      regex: /(?:async\s+def|await\s+)/g,
      description: 'Async/await pattern',
      example: 'async def func(): await ...'
    },
    'class-patterns': {
      regex: /class\s+\w+\s*(?:\([^)]*\))?:/g,
      description: 'Class definition pattern',
      example: 'class MyClass(Base): ...'
    }
  },
  
  // Go patterns
  go: {
    'interface-patterns': {
      regex: /type\s+\w+\s+interface\s*\{/g,
      description: 'Interface implementation',
      example: 'type Reader interface { ... }'
    },
    'error-handling': {
      regex: /if\s+err\s*!=\s*nil\s*\{/g,
      description: 'Error handling pattern',
      example: 'if err != nil { ... }'
    },
    'goroutine-patterns': {
      regex: /go\s+(?:func\s*\(\s*\)|\w+)/g,
      description: 'Goroutine pattern',
      example: 'go func() { ... }()'
    },
    'middleware': {
      regex: /func\s+\w+\s*\([^)]*\)\s*http\.Handler/g,
      description: 'Middleware implementation',
      example: 'func Middleware(next http.Handler) http.Handler { ... }'
    }
  }
};

// Language file extensions
const LANGUAGE_EXTENSIONS = {
  'dart': ['dart'],
  'js': ['js', 'jsx'],
  'ts': ['ts', 'tsx'],
  'py': ['py'],
  'go': ['go'],
  'rs': ['rs'],
  'java': ['java'],
  'rb': ['rb']
};

/**
 * Parse command line arguments
 */
function parseArgs(args) {
  const parsed = {
    pattern: null,
    language: null,
    depth: 'deep',
    output: 'text'
  };
  
  for (const arg of args) {
    if (arg.startsWith('--pattern=')) {
      parsed.pattern = arg.substring(10);
    } else if (arg.startsWith('--language=')) {
      parsed.language = arg.substring(11);
    } else if (arg.startsWith('--depth=')) {
      parsed.depth = arg.substring(8);
    } else if (arg.startsWith('--output=')) {
      parsed.output = arg.substring(9);
    }
  }
  
  return parsed;
}

/**
 * Get search path based on depth
 */
function getSearchPath(depth) {
  switch (depth) {
    case 'shallow':
      return '.';
    case 'medium':
      return 'lib/';
    case 'deep':
    default:
      return '.';
  }
}

/**
 * Get file extensions for language filter
 */
function getExtensions(language) {
  if (!language) return null;
  
  const lang = language.toLowerCase();
  return LANGUAGE_EXTENSIONS[lang] || [lang];
}

/**
 * Get pattern definition
 */
function getPattern(patternName, language) {
  // Check if it's a predefined pattern
  if (language && PREDEFINED_PATTERNS[language.toLowerCase()]) {
    const langPatterns = PREDEFINED_PATTERNS[language.toLowerCase()];
    if (langPatterns[patternName]) {
      return langPatterns[patternName];
    }
  }
  
  // Search all languages for the pattern name
  for (const lang of Object.keys(PREDEFINED_PATTERNS)) {
    if (PREDEFINED_PATTERNS[lang][patternName]) {
      return PREDEFINED_PATTERNS[lang][patternName];
    }
  }
  
  // If no predefined pattern, treat patternName as a regex
  try {
    return {
      regex: new RegExp(patternName, 'g'),
      description: `Custom pattern: ${patternName}`,
      example: null
    };
  } catch (e) {
    return null;
  }
}

/**
 * Search files using glob pattern
 */
function findFiles(searchPath, extensions) {
  try {
    let globPattern;
    if (extensions) {
      const extPattern = extensions.length === 1 
        ? `**/*.${extensions[0]}` 
        : `**/*.{${extensions.join(',')}}`;
      globPattern = path.join(searchPath, extPattern);
    } else {
      globPattern = path.join(searchPath, '**/*');
    }
    
    // Use Node.js to recursively find files
    const files = [];
    
    function traverse(dir) {
      const items = fs.readdirSync(dir);
      for (const item of items) {
        const fullPath = path.join(dir, item);
        const stat = fs.statSync(fullPath);
        
        // Skip node_modules, .git, and other hidden directories
        if (stat.isDirectory()) {
          if (!item.startsWith('.') && item !== 'node_modules' && item !== 'build') {
            traverse(fullPath);
          }
        } else if (stat.isFile()) {
          if (!extensions || extensions.some(ext => item.endsWith(`.${ext}`))) {
            files.push(fullPath);
          }
        }
      }
    }
    
    if (fs.existsSync(searchPath)) {
      traverse(searchPath);
    }
    
    return files;
  } catch (e) {
    console.error(`Error finding files: ${e.message}`);
    return [];
  }
}

/**
 * Search for pattern in file
 */
function searchPatternInFile(filePath, pattern) {
  try {
    const content = fs.readFileSync(filePath, 'utf8');
    const lines = content.split('\n');
    const matches = [];
    
    // Reset regex lastIndex
    pattern.regex.lastIndex = 0;
    
    let match;
    while ((match = pattern.regex.exec(content)) !== null) {
      // Find line number
      const matchIndex = match.index;
      let lineNumber = 1;
      let charCount = 0;
      
      for (let i = 0; i < lines.length; i++) {
        if (charCount + lines[i].length + 1 > matchIndex) {
          lineNumber = i + 1;
          break;
        }
        charCount += lines[i].length + 1;
      }
      
      // Extract context (surrounding lines)
      const contextStart = Math.max(0, lineNumber - 2);
      const contextEnd = Math.min(lines.length, lineNumber + 2);
      const context = lines.slice(contextStart, contextEnd).join('\n').trim();
      
      matches.push({
        line: lineNumber,
        match: match[0].substring(0, 100), // Limit match length
        context: context.substring(0, 200) // Limit context length
      });
    }
    
    return matches;
  } catch (e) {
    return [];
  }
}

/**
 * Calculate similarity between two implementations
 */
function calculateSimilarity(impl1, impl2) {
  // Simple similarity based on structure
  const text1 = impl1.match || '';
  const text2 = impl2.match || '';
  
  // Calculate basic similarity
  const len1 = text1.length;
  const len2 = text2.length;
  const maxLen = Math.max(len1, len2);
  
  if (maxLen === 0) return 1.0;
  
  // Simple Levenshtein-inspired similarity
  let common = 0;
  const minLen = Math.min(len1, len2);
  for (let i = 0; i < minLen; i++) {
    if (text1[i] === text2[i]) common++;
  }
  
  return Math.round((common / maxLen) * 100) / 100;
}

/**
 * Analyze patterns across files
 */
function analyzePatterns(files, pattern) {
  const results = [];
  
  for (const file of files) {
    const matches = searchPatternInFile(file, pattern);
    
    for (const match of matches) {
      results.push({
        file: file,
        line: match.line,
        match: match.match,
        context: match.context
      });
    }
  }
  
  return results;
}

/**
 * Generate refactoring suggestions
 */
function generateSuggestions(results, patternName) {
  const suggestions = [];
  
  if (results.length === 0) {
    return suggestions;
  }
  
  // Check for duplication
  if (results.length > 5) {
    suggestions.push(`Found ${results.length} occurrences of "${patternName}" - consider extracting to a shared utility`);
  }
  
  // Check for consistency
  const files = [...new Set(results.map(r => r.file))];
  if (files.length > 3) {
    suggestions.push(`Pattern spread across ${files.length} files - ensure consistent implementation`);
  }
  
  // Check for similarity variance
  if (results.length > 1) {
    const similarities = [];
    for (let i = 0; i < Math.min(results.length - 1, 5); i++) {
      const sim = calculateSimilarity(results[i], results[i + 1]);
      similarities.push(sim);
    }
    
    const avgSimilarity = similarities.reduce((a, b) => a + b, 0) / similarities.length;
    if (avgSimilarity < 0.7) {
      suggestions.push(`Low similarity (${Math.round(avgSimilarity * 100)}%) between implementations - standardize approach`);
    }
  }
  
  // Pattern-specific suggestions
  switch (patternName) {
    case 'error-handling':
      suggestions.push('Consider creating a centralized error handler');
      break;
    case 'repository':
      suggestions.push('Review repository methods for consistency in error handling');
      break;
    case 'bloc':
      suggestions.push('Ensure all BLoCs follow the same state management pattern');
      break;
  }
  
  return suggestions;
}

/**
 * Generate quality insights
 */
function generateInsights(results) {
  const insights = [];
  
  if (results.length === 0) {
    insights.push('No pattern occurrences found - verify pattern name or search criteria');
    return insights;
  }
  
  const files = [...new Set(results.map(r => r.file))];
  
  insights.push(`Pattern found in ${results.length} location(s) across ${files.length} file(s)`);
  
  // Calculate average similarity
  if (results.length > 1) {
    let totalSim = 0;
    let count = 0;
    
    for (let i = 0; i < results.length - 1; i++) {
      for (let j = i + 1; j < results.length; j++) {
        totalSim += calculateSimilarity(results[i], results[j]);
        count++;
      }
    }
    
    const avgSim = count > 0 ? Math.round((totalSim / count) * 100) : 0;
    insights.push(`Average implementation similarity: ${avgSim}%`);
    
    if (avgSim > 90) {
      insights.push('High consistency - implementations follow a standardized pattern');
    } else if (avgSim < 50) {
      insights.push('Low consistency - implementations vary significantly');
    }
  }
  
  return insights;
}

/**
 * Format results as text
 */
function formatText(patternName, pattern, results) {
  const lines = [];
  
  lines.push('Pattern Analysis Report');
  lines.push('=======================');
  lines.push('');
  lines.push(`Pattern: ${patternName}`);
  lines.push(`Description: ${pattern.description}`);
  if (pattern.example) {
    lines.push(`Example: ${pattern.example}`);
  }
  lines.push(`Occurrences: ${results.length}`);
  lines.push('');
  
  const files = [...new Set(results.map(r => r.file))];
  lines.push(`Files: ${files.length > 0 ? files.join(', ') : 'None'}`);
  lines.push('');
  
  if (results.length > 0) {
    lines.push('Implementations:');
    results.forEach((result, index) => {
      const relativePath = result.file.replace(process.cwd() + path.sep, '');
      lines.push(`  ${index + 1}. ${relativePath}:${result.line} - ${result.match.substring(0, 50)}...`);
    });
    lines.push('');
  }
  
  const suggestions = generateSuggestions(results, patternName);
  if (suggestions.length > 0) {
    lines.push('Refactoring Suggestions:');
    suggestions.forEach(s => lines.push(`  - ${s}`));
    lines.push('');
  }
  
  const insights = generateInsights(results);
  lines.push('Quality Insights:');
  insights.forEach(i => lines.push(`  - ${i}`));
  lines.push('');
  
  return lines.join('\n');
}

/**
 * Format results as JSON
 */
function formatJSON(patternName, pattern, results) {
  const files = [...new Set(results.map(r => r.file))];
  const suggestions = generateSuggestions(results, patternName);
  const insights = generateInsights(results);
  
  const implementations = results.map((result, index) => ({
    file: result.file,
    line: result.line,
    description: result.match.substring(0, 100),
    context: result.context.substring(0, 200),
    similarity: index > 0 ? calculateSimilarity(results[0], result) : 1.0
  }));
  
  return JSON.stringify({
    pattern: patternName,
    description: pattern.description,
    occurrences: results.length,
    files: files,
    implementations: implementations,
    suggestions: suggestions,
    insights: insights
  }, null, 2);
}

/**
 * Format results as Markdown
 */
function formatMarkdown(patternName, pattern, results) {
  const lines = [];
  
  lines.push(`# Pattern Analysis: ${patternName}`);
  lines.push('');
  lines.push(`**Description**: ${pattern.description}`);
  if (pattern.example) {
    lines.push(`**Example**: \`${pattern.example}\``);
  }
  lines.push('');
  lines.push(`**Occurrences**: ${results.length}`);
  
  const files = [...new Set(results.map(r => r.file))];
  lines.push(`**Files**: ${files.length}`);
  lines.push('');
  
  if (results.length > 0) {
    lines.push('## Implementations');
    lines.push('');
    lines.push('| # | File | Line | Match |');
    lines.push('|---|------|------|-------|');
    
    results.forEach((result, index) => {
      const relativePath = result.file.replace(process.cwd() + path.sep, '');
      const match = result.match.substring(0, 50).replace(/\|/g, '\\|');
      lines.push(`| ${index + 1} | \`${relativePath}\` | ${result.line} | \`${match}...\` |`);
    });
    
    lines.push('');
  }
  
  const suggestions = generateSuggestions(results, patternName);
  if (suggestions.length > 0) {
    lines.push('## Refactoring Suggestions');
    lines.push('');
    suggestions.forEach(s => lines.push(`- ${s}`));
    lines.push('');
  }
  
  const insights = generateInsights(results);
  lines.push('## Quality Insights');
  lines.push('');
  insights.forEach(i => lines.push(`- ${i}`));
  lines.push('');
  
  return lines.join('\n');
}

/**
 * Main execution
 */
async function main() {
  const args = process.argv.slice(2);
  const parsed = parseArgs(args);
  
  // Validate pattern
  if (!parsed.pattern) {
    console.log('Usage: /analyze-patterns --pattern=<pattern> [--language=<lang>] [--depth=<level>] [--output=<format>]');
    console.log('');
    console.log('Predefined patterns for Dart/Flutter:');
    console.log('  - repository     : Repository pattern implementations');
    console.log('  - bloc           : BLoC pattern implementations');
    console.log('  - freezed-model  : Freezed immutable models');
    console.log('  - dao            : Drift DAO patterns');
    console.log('  - error-handling : Try-catch with Result pattern');
    console.log('  - singleton      : Singleton pattern');
    console.log('  - table-definition: Drift table definitions');
    console.log('  - result-pattern : Result pattern return statements');
    console.log('');
    console.log('Other predefined patterns: singleton, factory, observer, async-patterns, api-endpoint, middleware');
    console.log('');
    console.log('Examples:');
    console.log('  /analyze-patterns --pattern=repository --language=dart');
    console.log('  /analyze-patterns --pattern=error-handling --output=json');
    console.log('  /analyze-patterns --pattern="class.*Repository" --depth=deep');
    process.exit(0);
  }
  
  // Get pattern definition
  const pattern = getPattern(parsed.pattern, parsed.language);
  
  if (!pattern) {
    console.error(`Error: Invalid pattern "${parsed.pattern}"`);
    console.error('Use --pattern=<name> with a predefined pattern name or valid regex');
    process.exit(1);
  }
  
  // Determine search parameters
  const searchPath = getSearchPath(parsed.depth);
  const extensions = getExtensions(parsed.language);
  
  console.log(`Searching for pattern "${parsed.pattern}"...`);
  console.log(`  Path: ${searchPath}`);
  console.log(`  Language: ${parsed.language || 'any'}`);
  console.log(`  Extensions: ${extensions ? extensions.join(', ') : 'all'}`);
  console.log('');
  
  // Find files
  const files = findFiles(searchPath, extensions);
  
  if (files.length === 0) {
    console.log('No files found matching the criteria.');
    process.exit(0);
  }
  
  console.log(`Found ${files.length} file(s) to analyze...`);
  console.log('');
  
  // Analyze patterns
  const results = analyzePatterns(files, pattern);
  
  // Format output
  let output;
  switch (parsed.output) {
    case 'json':
      output = formatJSON(parsed.pattern, pattern, results);
      break;
    case 'markdown':
      output = formatMarkdown(parsed.pattern, pattern, results);
      break;
    case 'text':
    default:
      output = formatText(parsed.pattern, pattern, results);
      break;
  }
  
  console.log(output);
}

// Run main
main().catch(err => {
  console.error('Error:', err.message);
  process.exit(1);
});
