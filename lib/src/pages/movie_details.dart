import 'package:flutter/material.dart';
import 'package:movies/src/models/actor_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';



class MovieDetails extends StatelessWidget {

  @override
  Widget build(BuildContext context) {


    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0,),

                _posterTitle(context, movie),
                _description(context, movie),
                _createCasting(movie)

              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _createAppBar(Movie movie) {

    return SliverAppBar(
      
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          movie.title,

          style: TextStyle(color: Colors.white, fontSize: 16.0),
        ),
        background: FadeInImage(
          image: NetworkImage(movie.getBackgroundImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
      ),
    );

  }

  Widget _posterTitle(BuildContext context, Movie movie) {

    return Container(

      padding: EdgeInsets.symmetric(horizontal:10.0),

      child: Row(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image(
              image: NetworkImage(movie.getPosterImg()),
              height: 150.0,
            ),
          ),
          SizedBox(width: 10,),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children: <Widget>[
                
                Text(
                  movie.originalTitle, 
                  style: Theme.of(context).textTheme.title, 
                  overflow: TextOverflow.ellipsis,
                ),

                Row(
                  
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(movie.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis)
                  ],
                )
              ],
            )
          )
        ],
      ),
    );



  }

  Widget _description(BuildContext context, Movie movie) {

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(
        movie.overview,

        textAlign: TextAlign.justify,
      ),
    );



  }

  Widget _createCasting(Movie movie) {

    final movieProvider = new MoviesProvider();

    return FutureBuilder(
      future: movieProvider.getCast(movie.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot){
        if(snapshot.hasData){
          return _createActorsPageView(snapshot.data);
        }
         else if(snapshot.error){
          return AlertDialog();
        }
         else {
          return Center(child: CircularProgressIndicator(),);
        }
        
      }
    );


  }

  Widget _createActorsPageView(List<Actor> actors) {

    return SizedBox(

      height: 200,

      child: PageView.builder(
        pageSnapping: false,

        controller: PageController(

          viewportFraction: 0.3,
          initialPage: 1

        ),

        itemCount: actors.length,
        itemBuilder: ( context, i){

          return Text(actors[i].name);
        }

      ),
    );


  }
}