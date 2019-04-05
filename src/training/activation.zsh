#!/bin/zsh

ACTIVATION_FUNCS="identity binarystep sigmoid tanh arctan arcsinh elliotsig \
isru isrlu relu prelu elu selu srelu softplus bentidentity sinusoid sinc \
gaussian softmax"

function activ_identity()
{
    echo $1
}

function activ_d_identity()
{
    echo 1.0
}

function activ_binarystep()
{
    echo $(($1 < 0 ? 0. : 1.))
}

function activ_d_binarystep()
{
    echo 0.0
}

function activ_sigmoid()
{
    echo $(( 1. / (1. + exp(-$1)) ))
}

function activ_d_sigmoid()
{
    echo $(( $(activ_sigmoid "$@") * (1 - $(activ_sigmoid "$@")) ))
}

function activ_tanh()
{
    echo $(( tanh($1) ))
}

function activ_d_tanh()
{
    echo $(( 1 - tanh($1) ** 2 ))
}

function activ_arctan()
{
    echo $(( atan($1) ))
}

function activ_d_arctan()
{
    echo $(( 1. / ($1 ** 2 + 1) ))
}

function activ_arcsinh()
{
    echo $(( asinh($1) ))
}

function activ_d_arcsinh()
{
    echo $(( 1. / sqrt(1 + $1 ** 2) ))
}

function activ_elliotsig()
{
    echo $(( $1 / (1. + abs($1))  ))
}

function activ_d_elliotsig()
{
    echo $(( 1. / ((1. + abs($1)) ** 2)  ))
}

# Parameters: alpha
function activ_isru()
{
    echo $(( $1 / sqrt(1. + $2 * $1 ** 2)  ))
}

# Parameters: alpha
function activ_d_isru()
{
    echo $(( 1. / sqrt(1. + $2 * $1 ** 2) ** 3 ))
}

function activ_isrlu()
{
    echo $(( $1 < 0 ? $(activ_isru "$@") : $1 ))
}

function activ_isrlu()
{
    echo $(( $1 < 0 ? $(activ_d_isru "$@") : 1. ))
}

function activ_relu()
{
    echo $(( $1 < 0 ? 0.0 : $1 ))
}

function activ_d_relu()
{
    echo $(( $1 < 0 ? 0.0 : 1.0 ))
}

# Parameters: alpha
function activ_prelu()
{
    echo $(( $1 < 0 ? $1 * $2 : $1 ))
}

# Parameters: alpha
function activ_d_prelu()
{
    echo $(( $1 < 0 ? $2 : 1.0 ))
}

# Parameters: alpha
function activ_elu()
{
    echo $(( $1 < 0 ? $2 * exp($1 - 1) : $1 ))
}

# Parameters: alpha
function activ_d_elu()
{
    echo $(( $1 < 0 ? $(activ_elu "$@") + $2  : 1.0 ))
}

# Parameters: alpha, lambda
function activ_selu()
{
    set $1 $2
    echo $(( $1 < 0 ? $2 * $3 * exp($1 - 1.) : $1 * $3 ))
}

# Parameters: alpha, lambda
function activ_d_selu()
{
    set $1 $2
    echo $(( $1 < 0 ? $2 * $3 * exp($1 - 1.) + $2  : $3 ))
}

# Parameters: Tl, Al, Tr, Ar
function activ_srelu()
{
    set $1 $2

    x=$1
    Tl=$2
    Al=$3
    Tr=$4
    Ar=$5

    if (( $x < $Tl ));
    then
        d=$((x - Tl))
        echo $((Tl + Al * d))
    elif (( $x < $Tr ));
    then
        echo $(( x ))
    else
        d=$((x - Tr))
        echo $((Tr + Ar * d))
    fi
}

# Parameters: Tl, Al, Tr, Ar
function activ_srelu()
{
    set $1 $2

    x=$1
    Tl=$2
    Al=$3
    Tr=$4
    Ar=$5

    if (( $x < $Tl ));
    then
        echo $Al
    elif (( $x < $Tr ));
    then
        echo 1.0
    else
        echo $Ar
    fi
}

function activ_softplus()
{
    echo $(( log(1. + exp($1)) ))
}

function activ_d_softplus()
{
    echo $(( 1. / (1. + exp( -+$1)) ))
}

function activ_bentidentity()
{
    echo $(( sqrt($1 ** 2 + 1.) / 2. - 0.5 + $1 ))
}

function activ_d_bentidentity()
{
    echo $(( $1 / (2. * sqrt($1 ** 2 + 1.)) + 1. ))
}

function activ_sinusoid()
{
    echo $(( sin($1) ))
}

function activ_d_sinusoid()
{
    echo $(( cos($1) ))
}

function activ_d_sinc()
{
    echo $(( $1 == 0 ? 0. : sin($1) / $1 ))
}

function activ_d_sinc()
{
    echo $(( $1 == 0 ? 0. : cos($1) / $1 - sin($1) / $1 ))
}

function activ_gaussian()
{
    echo $(( exp(-($1 ** 2)) ))
}

function activ_d_gaussian()
{
    echo $(( -2. * $1 * exp(-($1 ** 2)) ))
}

function activ_softmax()
{
    ex=$(($1 ** 2))
    sum=$ex

    shift 2

    for v in "$@";
    do
        sum=$((sum + exp(v)))
    done

    echo $(( ex / sum ))
}
