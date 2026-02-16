import '../models/models.dart';
import 'constants.dart';

class SeedData {
  static const fruits = [
    Fruit(
      name: 'apple',
      image: Assets.apple,
    ),
    Fruit(
      name: 'banana',
      image: Assets.banana,
    ),
    Fruit(
      name: 'carrot',
      image: Assets.carrot,
    ),
    Fruit(
      name: 'chili pepper',
      image: Assets.chiliPepper,
    ),
    Fruit(
      name: 'grape',
      image: Assets.grape,
    ),
    Fruit(
      name: 'lemon',
      image: Assets.lemon,
    ),
    Fruit(
      name: 'orange',
      image: Assets.orange,
    ),
    Fruit(
      name: 'pear',
      image: Assets.pear,
    ),
    Fruit(
      name: 'pineapple',
      image: Assets.pineapple,
    ),
    Fruit(
      name: 'squash',
      image: Assets.squash,
    ),
    Fruit(
      name: 'strawberry',
      image: Assets.strawberry,
    ),
    Fruit(
      name: 'tomato',
      image: Assets.tomato,
    ),
    Fruit(
      name: 'watermelon',
      image: Assets.watermelon,
    ),
  ];

  static const words = [
    Question(
      question: 'Fox wearing a necktie',
      image: Assets.foxWearingNecktie,
      difficulty: Difficulty.hard,
    ),
    Question(
      question: 'Bird feeding worm',
      image: Assets.birdFeedingWorm,
      difficulty: Difficulty.hard,
    ),
    Question(
      question: 'Rabbit with ball',
      image: Assets.rabbitWithBall,
      difficulty: Difficulty.hard,
    ),
    Question(
      question: 'There are two giraffes.',
      image: Assets.giraffe,
      difficulty: Difficulty.hard,
    ),
    Question(
      question: 'There is an alligator.',
      image: Assets.alligator,
      difficulty: Difficulty.hard,
    ),
    Question(
      question: 'alligator',
      image: Assets.alligator,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'ball',
      image: Assets.ball,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'cat',
      image: Assets.cat,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'duck',
      image: Assets.duck,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'elephant',
      image: Assets.elephant,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'fox',
      image: Assets.foxWearingNecktie,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'giraffe',
      image: Assets.giraffe,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'hat',
      image: Assets.hat,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'ice cream',
      image: Assets.iceCream,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'jar',
      image: Assets.jar,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'kite',
      image: Assets.kite,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'lion',
      image: Assets.lion,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'mice',
      image: Assets.mice,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'net',
      image: Assets.net,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'pig',
      image: Assets.pig,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'queen',
      image: Assets.queen,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'rabbit',
      image: Assets.rabbitWithBall,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'rainbow',
      image: Assets.rainbow,
      difficulty: Difficulty.easy,
    ),
  ];

  static const wordsV2 = [
    // Numbers (10 entries)
    Question(
      question: 'one',
      correctAnswer: 'one',
      image: Assets.numberOne,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'two',
      correctAnswer: 'two',
      image: Assets.numberTwo,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'three',
      correctAnswer: 'three',
      image: Assets.numberThree,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'four',
      correctAnswer: 'four',
      image: Assets.numberFour,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'five',
      correctAnswer: 'five',
      image: Assets.numberFive,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'six',
      correctAnswer: 'six',
      image: Assets.numberSix,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'seven',
      correctAnswer: 'seven',
      image: Assets.numberSeven,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'eight',
      correctAnswer: 'eight',
      image: Assets.numberEight,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'nine',
      correctAnswer: 'nine',
      image: Assets.numberNine,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'ten',
      correctAnswer: 'ten',
      image: Assets.numberTen,
      difficulty: Difficulty.easy,
    ),
    // Shapes (7 entries)
    Question(
      question: 'circle',
      correctAnswer: 'circle',
      image: Assets.circleDarkBrown,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'diamond',
      correctAnswer: 'diamond',
      image: Assets.diamondViolet,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'heart',
      correctAnswer: 'heart',
      image: Assets.heartPink,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'hexagon',
      correctAnswer: 'hexagon',
      image: Assets.hexagonBrown,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'rectangle',
      correctAnswer: 'rectangle',
      image: Assets.rectanglePink,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'square',
      correctAnswer: 'square',
      image: Assets.squareBlue,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'triangle',
      correctAnswer: 'triangle',
      image: Assets.triangleBlue,
      difficulty: Difficulty.easy,
    ),
    // Colors (8 entries)
    Question(
      question: 'brown',
      correctAnswer: 'brown',
      image: Assets.hexagonBrown,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'violet',
      correctAnswer: 'violet',
      image: Assets.diamondViolet,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'yellow',
      correctAnswer: 'yellow',
      image: Assets.diamondYellow,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'pink',
      correctAnswer: 'pink',
      image: Assets.heartPink,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'green',
      correctAnswer: 'green',
      image: Assets.trapezoidGreen,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'red',
      correctAnswer: 'red',
      image: Assets.triangleRed,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'blue',
      correctAnswer: 'blue',
      image: Assets.squareBlue,
      difficulty: Difficulty.easy,
    ),
    // Letters (26 entries)
    Question(
      question: 'a',
      correctAnswer: 'a',
      image: Assets.letterA,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'b',
      correctAnswer: 'b',
      image: Assets.letterB,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'c',
      correctAnswer: 'c',
      image: Assets.letterC,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'd',
      correctAnswer: 'd',
      image: Assets.letterD,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'e',
      correctAnswer: 'e',
      image: Assets.letterE,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'f',
      correctAnswer: 'f',
      image: Assets.letterF,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'g',
      correctAnswer: 'g',
      image: Assets.letterG,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'h',
      correctAnswer: 'h',
      image: Assets.letterH,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'i',
      correctAnswer: 'i',
      image: Assets.letterI,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'j',
      correctAnswer: 'j',
      image: Assets.letterJ,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'k',
      correctAnswer: 'k',
      image: Assets.letterK,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'l',
      correctAnswer: 'l',
      image: Assets.letterL,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'm',
      correctAnswer: 'm',
      image: Assets.letterM,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'n',
      correctAnswer: 'n',
      image: Assets.letterN,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'o',
      correctAnswer: 'o',
      image: Assets.letterO,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'p',
      correctAnswer: 'p',
      image: Assets.letterP,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'q',
      correctAnswer: 'q',
      image: Assets.letterQ,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'r',
      correctAnswer: 'r',
      image: Assets.letterR,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 's',
      correctAnswer: 's',
      image: Assets.letterS,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 't',
      correctAnswer: 't',
      image: Assets.letterT,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'u',
      correctAnswer: 'u',
      image: Assets.letterU,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'v',
      correctAnswer: 'v',
      image: Assets.letterV,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'w',
      correctAnswer: 'w',
      image: Assets.letterW,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'x',
      correctAnswer: 'x',
      image: Assets.letterX,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'y',
      correctAnswer: 'y',
      image: Assets.letterY,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'z',
      correctAnswer: 'z',
      image: Assets.letterZ,
      difficulty: Difficulty.easy,
    ),
  ];

  static const shapes = [
    Question(
      correctAnswer: 'circle',
      image: Assets.circle,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'heart',
      image: Assets.heart,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'hexagon',
      image: Assets.hexagon,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'oval',
      image: Assets.oval,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'pentagon',
      image: Assets.pentagon,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'rectangle',
      image: Assets.rectangle,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'square',
      image: Assets.square,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'star',
      image: Assets.star,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'trapezoid',
      image: Assets.trapezoid,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'triangle',
      image: Assets.triangle,
      difficulty: Difficulty.easy,
    ),
  ];

  static const shapeCutouts = [
    Question(
      correctAnswer: 'circle',
      image: Assets.circleCutout,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'heart',
      image: Assets.heartCutout,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'hexagon',
      image: Assets.hexagonCutout,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'oval',
      image: Assets.ovalCutout,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'rectangle',
      image: Assets.rectangle,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'square',
      image: Assets.squareCutout,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'star',
      image: Assets.starCutout,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'trapezoid',
      image: Assets.trapezoidCutout,
      difficulty: Difficulty.easy,
    ),
    Question(
      correctAnswer: 'triangle',
      image: Assets.triangleCutout,
      difficulty: Difficulty.easy,
    ),
  ];

  static const bubble = [
    Question(
      question: 'Ah, as in Apple',
      correctAnswer: 'a',
      image: Assets.bubbleA,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Buh, as in Ball',
      correctAnswer: 'b',
      image: Assets.bubbleB,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Kah, as in Cat',
      correctAnswer: 'c',
      image: Assets.bubbleC,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Duh, as in Dog',
      correctAnswer: 'd',
      image: Assets.bubbleD,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Eh, as in Egg',
      correctAnswer: 'e',
      image: Assets.bubbleE,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Fuh, as in Fish',
      correctAnswer: 'f',
      image: Assets.bubbleF,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Gah, as in Goat',
      correctAnswer: 'g',
      image: Assets.bubbleG,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Hah, as in House',
      correctAnswer: 'h',
      image: Assets.bubbleH,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Ieh, as in Igloo',
      correctAnswer: 'i',
      image: Assets.bubbleI,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Juh, as in Jar',
      correctAnswer: 'j',
      image: Assets.bubbleJ,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Kuh, as in Kite',
      correctAnswer: 'k',
      image: Assets.bubbleK,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Lah, as in Lion',
      correctAnswer: 'l',
      image: Assets.bubbleL,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Hmm, as in Moon',
      correctAnswer: 'm',
      image: Assets.bubbleM,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Innh, as in Nest',
      correctAnswer: 'n',
      image: Assets.bubbleN,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Oh, as in Orange',
      correctAnswer: 'o',
      image: Assets.bubbleO,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Puh, as in Pig',
      correctAnswer: 'p',
      image: Assets.bubbleP,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Kyu, as in Queen',
      correctAnswer: 'q',
      image: Assets.bubbleQ,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Rah, as in Rabbit',
      correctAnswer: 'r',
      image: Assets.bubbleR,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'S, as in Snake',
      correctAnswer: 's',
      image: Assets.bubbleS,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Tuh, as in Tiger',
      correctAnswer: 't',
      image: Assets.bubbleT,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Uh, as in Umbrella',
      correctAnswer: 'u',
      image: Assets.bubbleU,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Vuh, as Violin',
      correctAnswer: 'v',
      image: Assets.bubbleV,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Wuh, as in Water',
      correctAnswer: 'w',
      image: Assets.bubbleW,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'x, as in Xylophone',
      correctAnswer: 'x',
      image: Assets.bubbleX,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Yuh, as in Yoyo',
      correctAnswer: 'y',
      image: Assets.bubbleY,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'Zee, as in Zebra',
      correctAnswer: 'z',
      image: Assets.bubbleZ,
      difficulty: Difficulty.easy,
    ),
  ];

  static const colorShapes = [
    Question(
      question: 'circleTeal',
      correctAnswer: 'teal',
      image: Assets.circleTeal,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'circleDarkBrown',
      correctAnswer: 'dark_brown',
      image: Assets.circleDarkBrown,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'diamonViolet',
      correctAnswer: 'violet',
      image: Assets.diamondViolet,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'diamondYellow',
      correctAnswer: 'yellow',
      image: Assets.diamondYellow,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'heartTeal',
      correctAnswer: 'teal',
      image: Assets.heartTeal,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'heartPink',
      correctAnswer: 'pink',
      image: Assets.heartPink,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'heptagonBrown',
      correctAnswer: 'brown',
      image: Assets.heptagonBrown,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'heptagonGreen',
      correctAnswer: 'green',
      image: Assets.heptagonGreen,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'heptagonPurple',
      correctAnswer: 'purple',
      image: Assets.heptagonPurple,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'hexagonBrown',
      correctAnswer: 'brown',
      image: Assets.hexagonBrown,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'hexagonViolet',
      correctAnswer: 'violet',
      image: Assets.hexagonViolet,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'rectanglePink',
      correctAnswer: 'pink',
      image: Assets.rectanglePink,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'squareBlue',
      correctAnswer: 'blue',
      image: Assets.squareBlue,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'squareRed',
      correctAnswer: 'red',
      image: Assets.squareRed,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'trapezoidGreen',
      correctAnswer: 'green',
      image: Assets.trapezoidGreen,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'tapezoidPurple',
      correctAnswer: 'purple',
      image: Assets.trapezoidPurple,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'triangleBlue',
      correctAnswer: 'blue',
      image: Assets.triangleBlue,
      difficulty: Difficulty.easy,
    ),
    Question(
      question: 'triangleRed',
      correctAnswer: 'red',
      image: Assets.triangleRed,
      difficulty: Difficulty.easy,
    ),
  ];
}
