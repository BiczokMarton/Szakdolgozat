function cover_index(movie_title){
  var title = movie_title;

  function apiCall() {	
  	$.getJSON('https://www.omdbapi.com/?t='+ encodeURI(title)+'&apikey=847f91b9').then(function(response){
  		var image=response.Poster;
  		$('.movie').attr('src',image);


  	})	
  }
apiCall()
 }