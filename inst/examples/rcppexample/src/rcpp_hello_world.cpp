#include <Rcpp.h>
using namespace Rcpp;

#include "add.hpp"

// [[Rcpp::export]]
List rcpp_hello_world() {
    NumericVector x = NumericVector::create(3, 5);
    x.push_back(my_add(3, 5));
    int size = x.size();
    return List::create(x, size);
}
