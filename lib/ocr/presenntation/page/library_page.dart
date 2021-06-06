import 'package:envision_test/ocr/data/model/save_ocr.dart';
import 'package:envision_test/ocr/presenntation/page/display_page.dart';
import 'package:envision_test/ocr/presenntation/widget/library_item.dart';
import 'package:envision_test/util/ocr_bloc/ocr_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class LibraryPage extends StatefulWidget {

  LibraryPage({controller, Key key}): super(key: key) {
    tabController = controller;
  }

  @override
  _LibraryPageState createState() => _LibraryPageState();
}
TabController tabController;

class _LibraryPageState extends State<LibraryPage>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  GetOCRBloc _ocrBloc;
  final _controller = RefreshController(initialRefresh: false);
  List<SaveOcrModel> _savedOcrModel;
  List<SaveOcrModel> _sortedOcrModel;
  final _scrollController = ScrollController();
  int _indexTab = 0;
  final _tabController = ScrollController();
  List<double> _offsetContentOrigin = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _scrollController.addListener(_scrollListener);
    // _ocrBloc = BlocProvider.of<GetOCRBloc>(context);

    _ocrBloc = GetOCRBloc(GetOCRInitial());
    _ocrBloc.add(GetSavedEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _ocrBloc.add(GetSavedEvent());
    }
  }

  @override
  void didUpdateWidget(LibraryPage oldWidget) {
    _ocrBloc.add(GetSavedEvent());
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  ///ScrollListenerEvent
  void _scrollListener() {
    // if (_homePage?.listTab != null) {
    int activeTab = 0;
    double offsetTab;
    double widthDevice = MediaQuery.of(context).size.width;
    double itemSize = widthDevice / 3;
    double offsetStart = widthDevice / 2 - itemSize / 2;

    int indexCheck = _offsetContentOrigin.indexWhere((item) {
      return item - 1 > _scrollController.offset;
    });
    if (indexCheck == -1) {
      activeTab = _offsetContentOrigin.length - 1;
      offsetTab = offsetStart + itemSize * (activeTab - 3);
    } else if (indexCheck > 0) {
      activeTab = indexCheck - 1 > 0 ? indexCheck - 1 : 0;
      offsetTab = activeTab > 1 ? offsetStart + itemSize * (activeTab - 2) : 0;
    }

    if (activeTab != _indexTab) {
      setState(() {
        _indexTab = activeTab;
      });
    }
    if (offsetTab != null) {
      _tabController.jumpTo(offsetTab);
    }
    // }
  }

  ///On load more
  Future<void> _onLoading() async {
    _controller.loadComplete();
  }

  ///On refresh
  Future<void> _onRefresh() async {
    _controller.refreshCompleted();
  }

  ///Build list
  Widget _buildList() {
    if (_savedOcrModel == null) {
      return ListView(
        padding: EdgeInsets.only(top: 5),
        children: List.generate(8, (index) => index).map(
              (item) {
            return LibraryItem();
          },
        ).toList(),
      );
    }
    return ReorderableListView.builder(
        padding: EdgeInsets.only(top: 5),
        itemBuilder: (context, index) {
          final SaveOcrModel item = _savedOcrModel[index];
          return Dismissible(
            key: Key(item.timestamp.toString()),
            direction: DismissDirection.endToStart,
            child: LibraryItem(
              key: ValueKey(item.timestamp),
              item: item,
              onPressed: () {
                 Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DisplayPictureScreen(
                      item: item,
                    ),
                  ),
                );
              },
              border: _savedOcrModel.length - 1 != index,
            ),
            background: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Theme.of(context).accentColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                  )
                ],
              ),
            ),
            onDismissed: (direction) {
              _ocrBloc.add(DeleteEvent(item));
              _savedOcrModel.removeAt(index);
            },
          );
        },
        itemCount: _savedOcrModel == null ? 0 : _savedOcrModel.length,
        onReorder: (oldIndex, newIndex) {
          // final CreateEventModel item = _eventModel[oldIndex];
          // if(oldIndex > newIndex){
          //    _eventBloc.add(UpdatePosition(true, newIndex, oldIndex));
          // } else if(oldIndex < newIndex){
          //   newIndex -= 1;
          //    _eventBloc.add(UpdatePosition(false, oldIndex, newIndex));
          //
          // }
          // item.id = newIndex;
          // _eventBloc.add(UpdateEvent(item));
          //
          // _eventBloc.add(GetSavedEvent());
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: true,
          onRefresh: _onRefresh,
          onLoading: _onLoading,
          controller: _controller,
          header: ClassicHeader(
            idleText: "Pull down refresh",
            refreshingText: "Refreshing...",
            completeText: "Refresh completed",
            releaseText: "Release to refresh",
            refreshingIcon: SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          footer: ClassicFooter(
            loadingText:  "Loading...",
            canLoadingText: "Release to load more",
            idleText: "Pull up to load more",
            loadStyle: LoadStyle.ShowWhenLoading,
            loadingIcon: SizedBox(
              width: 16.0,
              height: 16.0,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          child: BlocListener<GetOCRBloc, GetsOCRState>(
            listener: (context, state) {
              if (state is EventSavedSuccessful) {
                Navigator.pop(context);
              }
            },
            child: BlocBuilder<GetOCRBloc, GetsOCRState>(
              bloc: _ocrBloc,
              builder: (context, state) {
                if (state is SaveLoading) {
                  _controller.refreshCompleted();
                }
                if (state is EventListSuccessful) {
                  _savedOcrModel = state.response;
                  _savedOcrModel = _savedOcrModel.reversed.toList();
                  return _buildList();
                }
                if (state is EventSavedSuccessful) {
                  Navigator.pop(context);
                }
                return _buildList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
