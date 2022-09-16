import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../common/navigation.dart';
import '../data/model/article.dart';
import '../provider/database_provider.dart';
import '../ui/article_detail_page.dart';

class CardArticle extends StatelessWidget {
  final Article article;

  const CardArticle({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        return FutureBuilder<bool>(
          future: provider.isBookmarked(article.url),
          builder: (context, snapshot) {
            var isBookmarked = snapshot.data ?? false;
            return Material(
              /// Tambahkan parameter trailing pada ListTile.
              /// Parameter ini akan menampilkan widget di sisi akhir dari ListTile.
              /// Tampilkan icon bookmark sekaligus aksi yang dilakukan berdasarkan status bookmark.
              child: ListTile(
                trailing: isBookmarked
                    ? IconButton(
                  icon: Icon(Icons.bookmark),
                  color: Theme.of(context).accentColor,
                  onPressed: () => provider.removeBookmark(article.url),
                )
                    : IconButton(
                  icon: Icon(Icons.bookmark_border),
                  color: Theme.of(context).accentColor,
                  onPressed: () => provider.addBookmark(article),
                ),
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: Hero(
                  tag: article.urlToImage!,
                  child: Image.network(
                    article.urlToImage!,
                    width: 100,
                  ),
                ),
                title: Text(
                  article.title,
                ),
                subtitle: Text(article.author!),
                onTap: () => Navigation.intentWithData(
                    ArticleDetailPage.routeName, article),
              ),
            );
          },
        );
      },
    );
  }
}