/*
  Sets
*/

%include <std_set.i>

%fragment("StdUnorderedSetTraits","header",fragment="<stddef.h>",fragment="StdSetTraits")
%{
  namespace swig {
    template <class RubySeq, class Key>
    inline void
    assign(const RubySeq& rubyseq, std::unordered_set<Key>* seq) {
      // seq->insert(rubyseq.begin(), rubyseq.end()); // not used as not always implemented
      typedef typename RubySeq::value_type value_type;
      typename RubySeq::const_iterator it = rubyseq.begin();
      for (;it != rubyseq.end(); ++it) {
	seq->insert(seq->end(),(value_type)(*it));
      }
    }

    template <class Key>
    struct traits_asptr<std::unordered_set<Key> >  {
      static int asptr(VALUE obj, std::unordered_set<Key> **s) {
	return traits_asptr_stdseq<std::unordered_set<Key> >::asptr(obj, s);
      }
    };

    template <class Key>
    struct traits_from<std::unordered_set<Key> > {
      static VALUE from(const std::unordered_set<Key>& vec) {
	return traits_from_stdseq<std::unordered_set<Key> >::from(vec);
      }
    };
  }
%}

#define %swig_unordered_set_methods(set...) %swig_set_methods(set)

%mixin std::unordered_set "Enumerable";

%rename("delete")     std::unordered_set::__delete__;
%rename("reject!")    std::unordered_set::reject_bang;
%rename("map!")       std::unordered_set::map_bang;
%rename("empty?")     std::unordered_set::empty;
%rename("include?" )  std::unordered_set::__contains__ const;
%rename("has_key?" )  std::unordered_set::has_key const;

%alias  std::unordered_set::push          "<<";

%include <std/std_unordered_set.i>
