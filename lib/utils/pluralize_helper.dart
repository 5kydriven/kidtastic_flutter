String pluralizeFruit({
  required String name,
  required int count,
}) {
  if (count == 1) return name;

  // Split compound names (e.g. "chili pepper" -> ["chili", "pepper"])
  final parts = name.split(' ');

  // Only pluralize the last word (main noun)
  final lastWord = parts.last;
  final pluralLastWord = _pluralizeWord(lastWord);

  // Replace the last word with its plural form
  parts[parts.length - 1] = pluralLastWord;

  // Rejoin the parts back
  return parts.join(' ');
}

String _pluralizeWord(String word) {
  // Handle common irregulars
  switch (word.toLowerCase()) {
    case 'tomato':
      return 'tomatoes';
    case 'potato':
      return 'potatoes';
    case 'leaf':
      return 'leaves';
    case 'loaf':
      return 'loaves';
    case 'knife':
      return 'knives';
    case 'wolf':
      return 'wolves';
    case 'deer':
    case 'fish':
    case 'sheep':
      // same singular/plural
      return word;
  }

  // Regular pluralization rules
  if (word.endsWith('y') &&
      !word.endsWith('ay') &&
      !word.endsWith('ey') &&
      !word.endsWith('oy')) {
    // e.g. strawberry -> strawberries
    return '${word.substring(0, word.length - 1)}ies';
  } else if (word.endsWith('o')) {
    // e.g. mango -> mangoes, tomato -> tomatoes
    return '${word}es';
  } else if (word.endsWith('ch') ||
      word.endsWith('sh') ||
      word.endsWith('x') ||
      word.endsWith('s')) {
    // e.g. peach -> peaches, squash -> squashes
    return '${word}es';
  } else {
    // default plural
    return '${word}s';
  }
}
