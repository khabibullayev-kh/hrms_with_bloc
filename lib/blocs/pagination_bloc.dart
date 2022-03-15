class PaginationBloc {

    static List<String> paginationWidget(
        int currentPage,
        int pageAmount,
        ) {
      int current = currentPage,
          last = pageAmount,
          delta = 2,
          left = current - delta,
          right = current + delta;
      List<String> pages = [];
      List range = [];
      int l = 0;
      for (int i = 1; i <= last; i++) {
        if (i == 1 || i == last || i >= left && i < right) {
          range.add("" + i.toString());
        }
      }
      pages.add('<<');
      for (String i in range) {
        if (l > 0) {
          if (int.parse(i) - l == 2) {
            pages.add("" + (l + 1).toString());
          } else if (int.parse(i) - l != 1) {
            pages.add('...');
          }
        }
        pages.add(i.toString());
        l = int.parse(i);
      }
      pages.add('>>');
      return pages;
    }

    static bool isNumeric(String s) {
      if (s == 'null' || s == '') {
        return false;
      }
      return double.tryParse(s) != null;
    }
}