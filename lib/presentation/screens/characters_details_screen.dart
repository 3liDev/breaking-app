// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:breaking_app/business_logic/cubit/characters_cubit.dart';
import 'package:breaking_app/constants/my_colors.dart';
import 'package:flutter/material.dart';

import 'package:breaking_app/data/models/characters.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CharactersDetailsScreen extends StatelessWidget {
  final Character character;
  const CharactersDetailsScreen({
    Key? key,
    required this.character,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getQuotesCubit(character.name);

    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(slivers: [
        buildSliverAppBar(),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                margin: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    characterInfo('Job : ', character.jobs.join(' / ')),
                    buildDivider(270),
                    characterInfo(
                        'Appeared in : ', character.categoryForTwoSeries),
                    buildDivider(205),
                    character.appearanceOfSeasons.isEmpty
                        ? Container()
                        : characterInfo('Seasons : ',
                            character.appearanceOfSeasons.join(' / ')),
                    character.appearanceOfSeasons.isEmpty
                        ? Container()
                        : buildDivider(235),
                    characterInfo('Status : ', character.statusIfDeadOrAlive),
                    buildDivider(248),
                    character.betterCallSaulAppearance.isEmpty
                        ? Container()
                        : characterInfo('Better Call Saul Seasons : ',
                            character.betterCallSaulAppearance.join(' / ')),
                    character.betterCallSaulAppearance.isEmpty
                        ? Container()
                        : buildDivider(105),
                    characterInfo('Actor/Actress : ', character.actorName),
                    buildDivider(190),
                    SizedBox(
                      height: 20.sp,
                    ),
                    BlocBuilder<CharactersCubit, CharactersState>(
                      builder: (context, state) {
                        return checkIfQuotesAreLoaded(state);
                      },
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 500.sp,
              )
            ],
          ),
        ),
      ]),
    );
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600.sp,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        //centerTitle: true,
        title: Text(
          character.nickName,
          style: const TextStyle(color: MyColors.myWhite),
          //textAlign: TextAlign.start,
        ),
        background: Hero(
            tag: character.charId,
            child: character.image.isNotEmpty
                ? FadeInImage.assetNetwork(
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: "assets/images/loading.gif",
                    image: character.image,
                    fit: BoxFit.cover,
                  )
                : Image.asset("assets/images/empty.png")

            //   Image.network(
            //   character.image.isEmpty
            //       ? "assets/images/empty.png"
            //       : character.image,
            //   fit: BoxFit.cover,
            // )
            ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: title,
            style: TextStyle(
              color: MyColors.myWhite,
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
            ),
          ),
          TextSpan(
            text: value,
            style: TextStyle(
              color: MyColors.myWhite,
              fontSize: 16.sp,
            ),
          )
        ],
      ),
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      height: 30.sp,
      endIndent: endIndent.w,
      color: MyColors.myBlue,
      thickness: 2,
    );
  }

  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuoteOrEmptySpace(state);
    } else {
      return showProgresssIndicator();
    }
  }

  Widget displayRandomQuoteOrEmptySpace(QuotesLoaded state) {
    var quotes = (state).quotes;
    if (quotes.isNotEmpty) {
      int randomQuoteIndex = Random().nextInt(quotes.length - 1);
      return DefaultTextStyle(
        textAlign: TextAlign.center,
        style:
            TextStyle(fontSize: 20.sp, color: MyColors.myWhite, shadows: const [
          Shadow(
            blurRadius: 7,
            color: MyColors.myBlue,
            offset: Offset(0, 0),
          )
        ]),
        child: Center(
          child: AnimatedTextKit(repeatForever: true, animatedTexts: [
            FlickerAnimatedText(quotes[randomQuoteIndex].quote),
          ]),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget showProgresssIndicator() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.myBlue,
      ),
    );
  }
}
