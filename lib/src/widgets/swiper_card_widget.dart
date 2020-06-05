import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:movies/src/models/movie_model.dart';


class SwiperCardWidget extends StatelessWidget {

  final List<Movie> movies;

  SwiperCardWidget ({ @required this.movies });


  @override
  Widget build(BuildContext context) {

    final _screenSize = MediaQuery.of(context).size;



    return Container(

      padding: EdgeInsets.only(top: 10.0),

      child: Swiper(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index){
          return ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(
                movies[index].getPosterImg(),
              ),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              fit: BoxFit.cover,
            )
          );
        },
        layout: SwiperLayout.STACK,
        itemHeight: _screenSize.height *0.5,
        itemWidth: _screenSize.width * 0.6,
      ),
    );
  }
}