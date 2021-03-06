MODULE ELEINV_MOD
CONTAINS
SUBROUTINE ELEINV(KM,KFC,KF_OUT_LT,PIA)

!**** *LEINV* - Inverse Legendre transform.

!     Purpose.
!     --------
!        Inverse Legendre tranform of all variables(kernel).

!**   Interface.
!     ----------
!        CALL LEINV(...)

!        Explicit arguments :  KM - zonal wavenumber (input-c)
!        --------------------  KFC - number of fields to tranform (input-c)
!                              PIA - spectral fields
!                              for zonal wavenumber KM (input)
!                              PAOA1 - antisymmetric part of Fourier
!                              fields for zonal wavenumber KM (output)
!                              PSOA1 - symmetric part of Fourier
!                              fields for zonal wavenumber KM (output)
!                              PLEPO - Legendre polonomials for zonal
!                              wavenumber KM (input-c)

!        Implicit arguments :  None.
!        --------------------

!     Method.
!     -------

!     Externals.   MXMAOP - calls SGEMVX (matrix multiply)
!     ----------

!     Reference.
!     ----------
!        ECMWF Research Department documentation of the IFS

!     Author.
!     -------
!        Mats Hamrud and Philippe Courtier  *ECMWF*

!     Modifications.
!     --------------
!        Original : 00-02-01 From LEINV in IFS CY22R1
!        M.Hamrud      01-Oct-2003 CY28 Cleaning
!        D. Degrauwe  (Feb 2012): Alternative extension zone (E')
!        R. El Khatib 01-Sep-2015 support for FFTW transforms

!     ------------------------------------------------------------------

USE PARKIND1  ,ONLY : JPIM, JPRB
USE YOMHOOK   ,ONLY : LHOOK,   DR_HOOK

USE TPM_DIM         ,ONLY : R
!USE TPM_GEOMETRY
!USE TPM_TRANS
#ifdef WITH_FFTW
USE TPM_FFTW     ,ONLY : TW,  EXEC_EFFTW
#endif
USE TPMALD_DIM      ,ONLY : RALD
USE TPMALD_FFT      ,ONLY : TALD
USE ABORT_TRANS_MOD ,ONLY : ABORT_TRANS
!

IMPLICIT NONE

INTEGER(KIND=JPIM), INTENT(IN)  :: KM
INTEGER(KIND=JPIM), INTENT(IN)  :: KFC
INTEGER(KIND=JPIM), INTENT(IN)  :: KF_OUT_LT
REAL(KIND=JPRB),    INTENT(INOUT)  :: PIA(:,:)

INTEGER(KIND=JPIM) :: IRLEN, ICLEN, IOFF, ITYPE
LOGICAL :: LL_ALL=.FALSE. ! T=do kfields ffts in one batch, F=do kfields ffts one at a time

REAL(KIND=JPRB) :: ZHOOK_HANDLE

!     ------------------------------------------------------------------

!*       1.       PERFORM LEGENDRE TRANFORM.
!                 --------------------------

IF (LHOOK) CALL DR_HOOK('ELEINV_MOD:ELEINV',0,ZHOOK_HANDLE)

IF (KFC>0) THEN
  ITYPE=1
  IRLEN=R%NDGL+R%NNOEXTZG
  ICLEN=RALD%NDGLSUR+R%NNOEXTZG
  IF( TALD%LFFT992 )THEN
    CALL FFT992(PIA,TALD%TRIGSE,TALD%NFAXE,1,RALD%NDGLSUR+R%NNOEXTZG,IRLEN,KFC,ITYPE)
#ifdef WITH_FFTW
  ELSEIF( TW%LFFTW )THEN
    IOFF=1
    CALL EXEC_EFFTW(ITYPE,IRLEN,ICLEN,IOFF,KFC,LL_ALL,PIA)
#endif
  ELSE
    CALL ABORT_TRANS('ELEINV_MOD:ELEINV: NO FFT PACKAGE SELECTED')
  ENDIF
ENDIF

IF (LHOOK) CALL DR_HOOK('ELEINV_MOD:ELEINV',1,ZHOOK_HANDLE)

END SUBROUTINE ELEINV
END MODULE ELEINV_MOD
