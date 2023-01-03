import 'package:flutter/material.dart';

Widget SearchBar(context) {
  return Container(
    padding:
    const EdgeInsets.only(left: 12, right: 12),
    height: 54,
    width: MediaQuery.of(context).size.width,
    child: TextField(
      cursorWidth: 1,
      cursorColor: Colors.black,
      maxLines: 1,
      textAlignVertical: TextAlignVertical.center,
      autofocus: false,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.grey[200],
        prefixIcon: const Icon(Icons.search, color: Colors.grey,),
        contentPadding: const EdgeInsets.only(top: 20),
        focusedBorder: const OutlineInputBorder(
          borderSide:
          BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide:
          BorderSide(width: 2, color: Colors.white),
          borderRadius: BorderRadius.all(Radius.circular(40)),
        ),
        hintText: 'Tìm kiếm',
        hintStyle: const TextStyle(
          color: Colors.grey,
        )
      ),
    ),
  );
}

Widget AvatarAndTitle(avatar, title) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SizedBox(
        width: 40,
        height: 40,
        child: CircleAvatar(
          backgroundImage: AssetImage(avatar),
          minRadius: 16,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          left: 12,
        ),
        child: Text(
          title,
          style:
          const TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    ],
  );
}

Widget TopTitle(title) {
  return Center(
    child: Container(
      margin: const EdgeInsets.only(bottom: 40),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 28,
          color: Colors.white,
        ),
      ),
    ),
  );
}

Widget editField(context, title, widget) {
  return Container(
    margin: const EdgeInsets.only(top: 16, left: 16, right: 16),
    color: Colors.white,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16, left: 16),
          child: Text(
            title,
            style: TextStyle(color: Colors.grey[700], fontSize: 15),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(bottom: 6),
          height: 55,
          width: MediaQuery.of(context).size.width,
          child: widget,
        ),
      ],
    ),
  );
}

Widget textFieldContainer(context, widget) {
  return Container(
    margin: const EdgeInsets.only(left: 24, right: 24, top: 12),
    height: MediaQuery.of(context).size.height * 0.1,
    child: widget,
  );
}
