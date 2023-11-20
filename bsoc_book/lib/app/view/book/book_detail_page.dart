import 'package:bsoc_book/app/models/book/book_model.dart';
import 'package:bsoc_book/app/models/book/list_comment_model.dart';
import 'package:bsoc_book/app/view/book/components/bookmark_list.dart';
import 'package:bsoc_book/app/view/book/components/chapter_book_list.dart';
import 'package:bsoc_book/app/view/book/components/comment_book_list.dart';
import 'package:bsoc_book/app/view/home/home_view.dart';
import 'package:bsoc_book/app/view_model/home_view_model.dart';
import 'package:bsoc_book/resource/values/app_colors.dart';
import 'package:bsoc_book/utils/widget_helper.dart';
import 'package:bsoc_book/widgets/app_dataglobal.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:share_plus/share_plus.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({
    super.key,
    required this.homeViewModel,
    required this.parentViewState,
  });
  final HomeViewModel homeViewModel;
  final HomeViewState parentViewState;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late HomeViewModel _homeViewModel;
  late BookModel _bookModel;
  int bookId = 0;
  bool _isLoading = false;
  List<ListCommentModel> _listComment = [];

  static const CHAPTER = 'chapter';
  static const ABOUT = 'about';
  static const COMMENT = 'comment';

  String currentTab = CHAPTER;

  @override
  void initState() {
    _homeViewModel = widget.homeViewModel;
    bookId = widget.homeViewModel.bookId;
    AppDataGlobal().currentBookId = bookId.toString();
    setState(() {
      _isLoading = true;
    });

    _homeViewModel.getBookDetailPage().then((value) {
      if (value != null) {
        setState(() {
          _isLoading = false;
        });
      }
    });

    _homeViewModel
        .getListCommentBook(bookId)
        .then((value) => {_listComment.addAll(value)});

    super.initState();
  }

  _setCurrentTab(String tab) {
    setState(() {
      currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: AppColors.PRIMARY_COLOR,
        elevation: 0,
        titleSpacing: 0,
        title: Text('Chi tiết sách'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (() {
            widget.parentViewState.jumpPageHome();
          }),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.share,
              color: Colors.white,
            ),
            onPressed: () {
              Share.share('Đọc ngay: ' +
                  _bookModel.bookName.toString() +
                  ' trên ứng dụng B4U BSOC '
                      '- Cài ứng dụng B4U BSOC tại AppStore: https://apps.apple.com/us/app/b4u-bsoc/id6444538062 ' +
                  ' - PlayStore: https://play.google.com/store/apps/details?id=com.b4usolution.b4u_bsoc');
            },
          ),
          IconButton(
              onPressed: () {
                if (AppDataGlobal().accessToken != '') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookmarkPage(
                              bookId: bookId,
                              homeViewModel: _homeViewModel,
                              parentViewState: widget.parentViewState,
                            )),
                  );
                } else {
                  WidgetHelper.showPopupMessage(
                      context: context,
                      content: const Text(
                          'Bạn cần đăng nhập để sử dụng chức năng này'));
                }
              },
              icon: const Icon(Icons.bookmark_sharp)),
          IconButton(
              onPressed: () {
                if (AppDataGlobal().accessToken != '') {
                  WidgetHelper.showPopupMessage(
                      header: 'Thông báo',
                      headerColor: AppColors.PRIMARY_COLOR,
                      context: context,
                      content: Text(
                        'Tính năng đang phát triển, vui lòng quay lại sau',
                        style: TextStyle(fontSize: 14.0),
                      ));
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) =>
                  //           DownloadPage()),
                  // );
                } else {
                  WidgetHelper.showPopupMessage(
                      context: context,
                      content: const Text(
                          'Bạn cần đăng nhập để sử dụng chức năng này'));
                }
              },
              icon: const Icon(Icons.download_for_offline))
        ],
      ),
      body: SafeArea(
        child: StreamBuilder(
            stream: widget.homeViewModel.bookDetailModelSubjectStream,
            builder: (context, snapshot) {
              _bookModel = widget.homeViewModel.bookDetailModel!;
              return (_isLoading == false)
                  ? Stack(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 15.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 150.0,
                                    child: Image.network(
                                      AppDataGlobal().domain +
                                          _bookModel.image.toString(),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          _bookModel.bookName.toString(),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 5,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Text(_bookModel.author.toString()),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            _renderTabButton(),
                            const SizedBox(
                              height: 15,
                            ),
                            _renderContent(_homeViewModel.bookDetailModel!,
                                _homeViewModel, widget.parentViewState)
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: LoadingAnimationWidget.discreteCircle(
                      color: Color.fromARGB(255, 138, 175, 52),
                      secondRingColor: Colors.black,
                      thirdRingColor: Colors.purple,
                      size: 30,
                    ));
            }),
      ),
    );
  }

  _renderTabButton() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.5, color: AppColors.PRIMARY_COLOR),
        // borderRadius: BorderRadius.circular(12)
      ),
      child: IntrinsicHeight(
          child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: InkWell(
                onTap: () => _setCurrentTab(CHAPTER),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: currentTab == CHAPTER
                        ? AppColors.PRIMARY_COLOR
                        : Colors.white,
                  ),
                  child: Center(
                      child: Text(
                    'Chương Sách',
                    style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: currentTab == CHAPTER
                            ? Colors.white
                            : AppColors.PRIMARY_COLOR),
                  )),
                ),
              )),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: AppColors.PRIMARY_COLOR,
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => _setCurrentTab(ABOUT),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: currentTab == ABOUT
                      ? AppColors.PRIMARY_COLOR
                      : Colors.white,
                ),
                child: Center(
                    child: Text(
                  'Mô Tả',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: currentTab == ABOUT
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR),
                )),
              ),
            ),
          ),
          const VerticalDivider(
            width: 1,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: AppColors.PRIMARY_COLOR,
          ),
          Expanded(
            flex: 2,
            child: InkWell(
              onTap: () => _setCurrentTab(COMMENT),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: currentTab == COMMENT
                      ? AppColors.PRIMARY_COLOR
                      : Colors.white,
                ),
                child: Center(
                    child: Text(
                  'Đánh Giá',
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: currentTab == COMMENT
                          ? Colors.white
                          : AppColors.PRIMARY_COLOR),
                )),
              ),
            ),
          ),
        ],
      )),
    );
  }

  _renderContent(BookModel bookModel, HomeViewModel homeViewModel,
      HomeViewState homeViewState) {
    if (currentTab == CHAPTER) {
      return ChapterBookList(
          bookModel: bookModel,
          chapterModel: bookModel.chapters,
          homeViewModel: homeViewModel,
          homeViewState: homeViewState);
    } else if (currentTab == ABOUT) {
      return Expanded(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              color: Colors.white,
              child: Text(
                bookModel.description.toString(),
                style: TextStyle(fontSize: 14.0),
              ),
            ),
          ),
        ),
      );
    } else if (currentTab == COMMENT) {
      return CommentBookList(
        bookId: bookId,
        homeViewModel: homeViewModel,
      );
    }
  }
}
