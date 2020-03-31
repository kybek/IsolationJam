#include <bits/stdc++.h>

using namespace std;

char m[50][50];

int main() {
  for (int i = 1; i <= 30; i++) {
    for (int j = 6; j <= 35; j++) {
      m[i][j] = '#';
    }
  }
  for (int i = 2; i <= 29; i++) {
    for (int j = 7; j <= 34; j++) {
      m[i][j] = '.';
    }
  }
  for (int i = 14; i <= 17; i++) {
    for (int j = 1; j <= 4; j++) {
      m[i][j] = '#';
    }
  }
  for (int i = 15; i <= 16; i++) {
    for (int j = 2; j <= 3; j++) {
      m[i][j] = '.';
    }
  }
  for (int i = 14; i <= 17; i++) {
    for (int j = 37; j <= 40; j++) {
      m[i][j] = '#';
    }
  }
  for (int i = 15; i <= 16; i++) {
    for (int j = 38; j <= 39; j++) {
      m[i][j] = '.';
    }
  }
  printf("[\n");
  for (int i = 1; i <= 30; i++) {
    printf("'");
    for (int j = 1; j <= 5; j++) {
      printf("t");
    }
    for (int j = 1; j <= 40; j++) {
      printf("%c", m[i][j] == 0 ? 't' : m[i][j]);
    }
    for (int j = 1; j <= 5; j++) {
      printf("t");
    }
    printf("',\n");
  }
  printf("]\n");
  return 0;
}