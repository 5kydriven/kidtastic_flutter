import 'package:flutter/material.dart';

import '../../../constants/constants.dart';

class ShapeGameBody extends StatelessWidget {
  const ShapeGameBody({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: SizedBox(
            height: size.height * 0.5,
            child: Card(
              elevation: 8,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(52)),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'What shape is this?',
                      style: TextStyle(
                        color: Color(0xffBC3740),
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: Image.asset(
                        Assets.triangle,
                        height: 200,
                        width: 200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(
                height: size.height * 0.65,
                child: GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  padding: const EdgeInsets.all(12),
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.5,
                  children: List.generate(
                    6,
                    (index) {
                      return Card(
                        elevation: 8,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                        child: Center(
                          child: Text(
                            '$index',
                            style: TextStyle(
                              color: Color(0xffCF5961),
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(
                height: size.height * 0.13,
                width: double.infinity,
                child: Card(
                  elevation: 8,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Score:',
                        style: const TextStyle(
                          fontSize: 32,
                          color: Color(0xffCF5961),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
