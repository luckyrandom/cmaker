
#include <Rcpp.h>
using namespace Rcpp;

#include "add.hpp"

// [[Rcpp::export]]
List rcpp_hello_world() {

    CharacterVector x = CharacterVector::create( "foo", "bar" )  ;
    NumericVector y   = NumericVector::create( 0.0, 1.0, add(3.5, 4.8)) ;
    List z            = List::create( _["x"] = x, _["y"] = y ) ;
    return z ;
}
