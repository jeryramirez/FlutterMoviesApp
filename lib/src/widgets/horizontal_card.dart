import 'package:flutter/material.dart';
import 'package:movies/src/models/movie_model.dart';


class HorizontalCard extends StatelessWidget {

  final List<Movie> movies;

  final Function nextPage;

  HorizontalCard({ @required this.movies, @required this.nextPage });

  final _pageController = new PageController(
    initialPage: 1,
    viewportFraction: 0.3
  );


  @override
  Widget build(BuildContext context) {
    
    final _screeSize = MediaQuery.of(context).size;


    _pageController.addListener( () {
      if (_pageController.position.pixels >= _pageController.position.maxScrollExtent - 200){
        
        nextPage();



      }
    });

    
    return Container(

      height: _screeSize.height * 0.3,
      child: PageView.builder(
        pageSnapping: false,
        controller: _pageController,
        itemBuilder: (context, i){
          return _card(context, movies[i]);
        },
        itemCount: movies.length,
      ),
      
    );
  }

  Widget _card(BuildContext context, Movie movie){

    
    final card = Container(
      child: Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(
          children: <Widget>[
            ClipRRect(

              borderRadius: BorderRadius.circular(20.0),

              child: FadeInImage(
                image: NetworkImage(movie.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0,
                
              )
            ),
            SizedBox(height: 5.0,),
            Text(
              movie.title,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.caption,
            )

          ],
        ),
      ),
    );

    return GestureDetector(
      child: card,
      onTap: (){
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );

  }

  // List<Widget>_cards(BuildContext context) {

  //   return movies.map( (movie){

  //     return Container(
  //       // padding: EdgeInsets.all(0),
  //       // margin: EdgeInsets.all(0),
  //       child: Container(
  //         margin: EdgeInsets.only(right: 15.0),
  //         child: Column(
  //           children: <Widget>[
  //             ClipRRect(

  //               borderRadius: BorderRadius.circular(20.0),

  //               child: FadeInImage(
  //                 image: NetworkImage(movie.getPosterImg()),
  //                 placeholder: AssetImage('assets/img/no-image.jpg'),
  //                 fit: BoxFit.cover,
  //                 height: 160.0,
                  
  //               )
  //             ),
  //             SizedBox(height: 5.0,),
  //             Text(
  //               movie.title,
  //               overflow: TextOverflow.ellipsis,
  //               style: Theme.of(context).textTheme.caption,
  //             )

  //           ],
  //         ),
  //       ),

  //     );


  //   }).toList();


  //  }
}