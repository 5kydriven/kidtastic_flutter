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
}
