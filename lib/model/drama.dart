class Drama {
  final String id;
  final String title;
  final String url;
  final String image;

  Drama(this.id, this.title, this.url, this.image);
}

class EpisodeDetails {
  final String id;
  final String title;
  final String eps;
  final String releaseDate;
  final String url;

  EpisodeDetails(this.id, this.title, this.eps, this.releaseDate, this.url);
}

class DramaDetails {
  final String id;
  final String title;
  final String OtherNames;
  final String image;
  final String des;
  final String releaseDate;
  final List<EpisodeDetails> Episodes;

  DramaDetails(this.id, this.title, this.OtherNames, this.image, this.des,
      this.releaseDate, this.Episodes);
}
