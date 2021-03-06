MODULE ELEDIR_MOD
CONTAINS
SUBROUTINE ELEDIR(KM,KFC,KLED2,PFFT)

!**** *ELEDIR* - Direct meridional transform.

!     Purpose.
!     --------
!        Direct meridional tranform of state variables.

!**   Interface.
!     ----------
!        CALL ELEDIR(...)

!        Explicit arguments :  KM - zonal wavenumber
!        --------------------  KFC - number of field to transform
!                              PAIA - antisymmetric part of Fourier
!                              fields for zonal wavenumber KM
!                              PSIA - symmetric part of Fourier
!                              fields for zonal wavenumber KM
!                              POA1 -  spectral
!                              fields for zonal wavenumber KM
!                              PLEPO - Legendre polonomials

!        Implicit arguments :  None.
!        --------------------

!     Method.
!     -------

!     Externals.   MXMAOP - matrix multiply
!     ----------

!     Reference.
!     ----------
!        ECMWF Research Department documentation of the IFS

!     Author.
!     -------
!        Mats Hamrud and Philippe Courtier  *ECMWF*

!     Modifications.
!     --------------
!        Original : 88-01-28
!        Modified : 91-07-01 Philippe Courtier/Mats Hamrud - Rewrite
!                            for uv formulation
!        Modified : 93-03-19 D. Giard - NTMAX instead of NSMAX
!        Modified : 04/06/99 D.Salmond : change order of AIA and SIA
!        M.Hamrud      01-Oct-2003 CY28 Cleaning
!        D. Degrauwe  (Feb 2012): Alternative extension zone (E')
!        R. El Khatib 01-Sep-2015 support for FFTW transforms
!     ------------------------------------------------------------------

USE PARKIND1  ,ONLY : JPIM, JPRB
USE YOMHOOK   ,ONLY : LHOOK,   DR_HOOK

USE TPM_DIM         ,ONLY : R
!USE TPM_GEOMETRY
!USE TPM_TRANS
USE TPMALD_FFT      ,ONLY : TALD
#ifdef WITH_FFTW
USE TPM_FFTW     ,ONLY : TW, EXEC_EFFTW
#endif
USE TPMALD_DIM      ,ONLY : RALD
USE ABORT_TRANS_MOD ,ONLY : ABORT_TRANS
!

IMPLICIT NONE

INTEGER(KIND=JPIM), INTENT(IN)  :: KM,KFC,KLED2
REAL(KIND=JPRB) ,   INTENT(INOUT)  :: PFFT(:,:)

INTEGER(KIND=JPIM) :: IRLEN, ICLEN, IOFF, ITYPE
LOGICAL :: LL_ALL=.FALSE. ! T=do kfields ffts in one batch, F=do kfields ffts one at a time
!     ------------------------------------------------------------------

!*       1.       PERFORM FOURIER TRANFORM.
!                 --------------------------

IF (KFC>0) THEN
  ITYPE=-1
  IRLEN=R%NDGL+R%NNOEXTZG
  ICLEN=RALD%NDGLSUR+R%NNOEXTZG
  IF( TALD%LFFT992 )THEN
    CALL FFT992(PFFT,TALD%TRIGSE,TALD%NFAXE,1,ICLEN,IRLEN,KFC,ITYPE)
#ifdef WITH_FFTW
  ELSEIF( TW%LFFTW )THEN
    IOFF=1
    CALL EXEC_EFFTW(ITYPE,IRLEN,ICLEN,IOFF,KFC,LL_ALL,PFFT)
#endif
  ELSE
    CALL ABORT_TRANS('ELEDIR_MOD:ELEDIR: NO FFT PACKAGE SELECTED')
  ENDIF
ENDIF

!     ------------------------------------------------------------------

END SUBROUTINE ELEDIR
END MODULE ELEDIR_MOD
