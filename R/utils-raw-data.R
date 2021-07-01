#' Re-generates Table 2 from (Berger and Loutre, 1990)
#'
#' Re-generates the precession amplitudes and frequencies based on files
#' provided by (Berger, 1978), (labelled Table 2 in the original publication).
#' The present routine is an implementation of the original article (Berger
#' and Loutre, 1990)
#' @param Table1 Tibble object.
#' @param Table4 Tibble object.
#' @param Table5 Tibble object.
#' @param sol Solution name, e.g., 'BER78'.
#'
#' @return Tibble with the precession amplitudes and frequencies.
#' @keywords internal
#'
#' @references
#'
#' Berger, A.L., 1978. Long-term variations of daily insolation and Quaternary climatic changes. Journal of Atmospheric Sciences, 35(12), pp.2362-2367.
#'
#' Berger, A.L. and Loutre, M.F., 1990. Origine des fréquences des éléments astronomiques intervenant dans le calcul de l'insolation. Bulletins de l'Académie Royale de Belgique, 1(1), pp.45-106.
generate_table2 <- function(Table1, Table4, Table5, sol = 'BER78') {
  if (sol == 'BER78') {
    P <- 50.439273
    zeta <- 3.392506
  } else if (sol == 'BER90') {
    P <- 50.41726176   # cf. eq. (31) in BER90
    zeta <- 1.60075265 # cf. eq. (30) in BER90
  }

  ## PsiBar
  g <- Table4[, 3]#$V3
  M <- Table4[, 2]#$V2
  beta <- Table4[, 4]#$V4
  F <- Table5[, 2] / 60. / 60. * pi / 180 #$V2/60./60.*pi/180
  f <- Table5[, 3]#$V3
  delta <- Table5[, 4]#$V4

  ## division in 3 groups, as in Table 13 and Table 14 of Berger & Loutre, Ac. Roy. 1990
  Fre <- c(g + P, outer(g, f, "+") + P, outer(g, f, "-") + P)
  Amp <- c(M, outer(M, F, "*") / 2., outer(M, F, "*") / 2.)
  Pha <- c(beta + zeta,
           outer(beta, delta, "+") + zeta,
           outer(beta, delta, "-") + zeta)

  ## regroup similar frequencies
  tol <- 0.0001
  Ntrun <- 200.

  Order <- order(abs(Amp), decreasing = TRUE)

  Amp <- Amp[Order]
  Fre <- Fre[Order]
  ## truncates the first 200 terms
  Fre <- Fre[1:Ntrun]
  Amp <- Amp[1:Ntrun]


  N <- length(Fre)
  for (i in 1:(N - 1)) {
    for (j in (i + 1):N) {
      if (abs(Fre[j] - Fre[i]) < tol) {
        Amp[i] <- Amp[i] + Amp[j]
        Amp[j] <- 0
      }
    }
  }

  Order <- order(abs(Amp), decreasing = TRUE)

  Amp <- Amp[Order]
  Fre <- Fre[Order]
  Pha <- (Pha[Order] + 180) %% 360.
  Per <- 360 * 60 * 60 / Fre / 1000.

  tibble::tibble(
    Index = seq(1, length(Amp)),
    Amp = Amp,
    Fre = Fre,
    Pha = Pha,
    Per = abs(Per[Order])
  )
}
