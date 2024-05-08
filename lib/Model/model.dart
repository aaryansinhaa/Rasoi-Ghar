class RecipeModel {
  late String label;
  late String url;
  late String imageUrl;
  late double calories;

  RecipeModel(
      {this.label = "LABEL",
      this.url = "URL",
      this.imageUrl = "IMAGE",
      this.calories = 0.00});
  factory RecipeModel.fromMap(Map recipe) {
    return RecipeModel(
      label: recipe["label"],
      url: recipe["url"],
      imageUrl: recipe["image"],
      calories: recipe["calories"],
    );
  }
}
