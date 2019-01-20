/* -------------------------------------------------------------------------
 * openacc.i
 * ------------------------------------------------------------------------- */
#ifdef SWIG_FORTRAN_CUDA
#error "Can't use both CUDA *and* OpenACC compatibility layers."
#endif
#define SWIG_FORTRAN_OPENACC

%include <forarray.swg>

// Load openacc types
%fragment("f_use_openacc", "fmodule") %{ use openacc %}

// Add array wrapper to Fortran types when used
%fragment("SwigDevArrayWrapper_f", "fparams", noblock=1,
          fragment="f_use_openacc") {
 type, bind(C) :: SwigDevArrayWrapper
  type(C_DEVPTR), public :: data = C_NULL_DEVPTR
  integer(C_SIZE_T), public :: size = 0
 end type
}

%define FORT_DEVICEPTR_TYPEMAP(VTYPE, CPPTYPE...)

  // Use array type for C interface
  FORT_ARRAYWRAP_TYPEMAP(CPPTYPE)

  // Override Fortran 'imtype': we want device pointer
  %typemap(imtype, fragment="SwigDevArrayWrapper_f") CPPTYPE
    "type(SwigDevArrayWrapper)"

  %typemap(fin, noblock=1, fragment="f_use_openacc") CPPTYPE {
    $1%data = acc_deviceptr($input)
    $1%size = size($input)
  }

  %typemap(ftype, noblock=1) CPPTYPE {
    $typemap(imtype, VTYPE), dimension(:)
  }

%enddef
