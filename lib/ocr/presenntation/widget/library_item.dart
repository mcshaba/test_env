import 'package:envision_test/ocr/data/model/save_ocr.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

class LibraryItem extends StatelessWidget {
  final SaveOcrModel item;
  final VoidCallback onPressed;
  final bool border;

  LibraryItem({
    Key key,
    this.item,
    this.onPressed,
    this.border = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item == null) {
      return Shimmer.fromColors(
        child: Container(
          padding: EdgeInsets.only(top: 8, bottom: 8, right: 20, left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            height: 10,
                            width: 150,
                            color: Colors.white,
                          ),
                          Container(
                            height: 10,
                            width: 50,
                            color: Colors.white,
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 5),
                      ),
                      Container(
                        height: 10,
                        color: Colors.white,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
        baseColor: Theme.of(context).hoverColor,
        highlightColor: Theme.of(context).highlightColor,
      );
    }
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 20, right: 20),
        decoration: BoxDecoration(
          border: border
              ? Border(
            bottom: BorderSide(
              width: 1,
              color: Theme.of(context).dividerColor,
            ),
          )
              : null,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
              child: Icon(
                Icons.note,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            item == null? "": item.message.substring(0, item.message.length > 20? 20:item.message.length),
                            maxLines: 1,
                            style: Theme.of(context).textTheme.subtitle2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),

                      ],
                    ),
                    Text(
                      DateFormat(
                          'MMM dd yyyy, hh:mm'
                      ).format(item.timestamp),
                      style: Theme.of(context).textTheme.bodyText2.copyWith(
                        fontWeight: FontWeight.w400, fontSize: 14, fontFamily: "Roboto"
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 3),
                    ),

                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
