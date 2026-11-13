
#define abort(msg) abort_routine(__LINE__,__FILE__,msg)

#define assert(condition) assert_routine(condition,"condition",__LINE__,__FILE__)
