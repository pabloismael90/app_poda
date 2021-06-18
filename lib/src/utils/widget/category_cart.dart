import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CategoryCard extends StatelessWidget {
    final String? svgSrc;
    final String? title;
    final Function? press;
    const CategoryCard({
        Key? key,
        this.svgSrc,
        this.title,
        this.press,
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Container(
            
            decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(13),
                boxShadow: [
                   BoxShadow(
                          color: Color(0xFF3A5160)
                              .withOpacity(0.05),
                          offset: const Offset(1.1, 1.1),
                          blurRadius: 17.0),
                ],
            ),
            child: InkWell(
                onTap: press as void Function()?,
                child: Padding(
                padding: const EdgeInsets.all(10.0),
                    child: Column(
                        children: <Widget>[
                            Spacer(),
                            SvgPicture.asset(svgSrc!, height: 60,),
                            Spacer(),
                            Text(
                                title!,
                                textAlign: TextAlign.center,
                                textScaleFactor: 1.0,
                                style: Theme.of(context).textTheme.headline6!.copyWith(fontWeight: FontWeight.w600, fontSize: 16, )
                            ),
                            Spacer(),
                        ],
                    ),
                ),
            ),
        );
    }
}