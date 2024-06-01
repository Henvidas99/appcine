import 'package:flutter/material.dart';


class GenreList extends StatelessWidget {
  final List<String> chipContents;

  const GenreList({
    Key? key,
    required this.chipContents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Padding(
        padding: EdgeInsets.only(bottom: 8.0, top: 5.0),
        child: Text(
          'Género:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      SizedBox(
        height: 30, // Altura para el ListView
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: chipContents.length,
          separatorBuilder: (ctx, i) => SizedBox(width: 20),
          itemBuilder: (ctx, i) => buildChipListItem(i),
        ),
      ),
    ],
  );
}


  Container buildChipListItem(int i) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(
        child: Text(
          chipContents[i],
          style: const TextStyle(
              color: Colors.grey,
              fontSize: 10,
              fontWeight: FontWeight.w600),
        ),
      ),
    );

}

}