import 'package:flutter/material.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/search/search_delegate.dart';
import 'package:movies/src/widgets/horizontal_card.dart';
import 'package:movies/src/widgets/swiper_card_widget.dart';

class HomePage extends StatelessWidget {


  final moviesProvider = new MoviesProvider();

  Size _screenSize ;


  @override
  Widget build(BuildContext context) {

    _screenSize = MediaQuery.of(context).size;

    moviesProvider.getMorePopular();

    return Scaffold(

      appBar: AppBar(
        title: Text('Movies on Cinema'),

        backgroundColor: Colors.indigoAccent,

        actions: <Widget>[

          IconButton(
            icon: Icon(Icons.search),

            onPressed: (){
              showSearch(context: context, delegate: DataSearch());
            },

          )
        ]
      ),
      body: Container(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: <Widget>[
            _swiperCardsWidget(),
            _footer(context)

          ],
        ),
      )
    );
  }

  Widget _swiperCardsWidget() {

    return FutureBuilder(

      future: moviesProvider.getNowPlaying(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){

        if(snapshot.hasData){

          return SwiperCardWidget(

            movies: snapshot.data,
          );
        }else{

          return Container(

            height: _screenSize.height * 0.8,
            child: Center(
              child: CircularProgressIndicator()
            )
          );

        }

      }
    );

  }

  Widget _footer(BuildContext context){
    return Container(

      width: double.infinity,

      child: Column(

        children: <Widget>[

          Text('More Popular', style: Theme.of(context).textTheme.subhead),

          StreamBuilder(

            stream: moviesProvider.popularStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {

              if( snapshot.hasData ){

                return HorizontalCard(

                  movies: snapshot.data,
                  nextPage: moviesProvider.getMorePopular,
                );
              } else {

                return CircularProgressIndicator();
              }
            },
          )
        ],
      ),
    );
  }


}