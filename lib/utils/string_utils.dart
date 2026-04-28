String normalize(String s) {
        return s
          .trim()
          .replaceAll(RegExp(r'\s+'), '')
          .toLowerCase();
      }