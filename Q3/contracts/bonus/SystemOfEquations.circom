pragma circom 2.0.0;

include "../../node_modules/circomlib/circuits/comparators.circom";
include "../../node_modules/circomlib/circuits/gates.circom";
include "../../node_modules/circomlib-matrix/circuits/matMul.circom";
include "../../node_modules/circomlib-matrix/circuits/transpose.circom"; // hint: you can use more than one templates in circomlib-matrix to help you

template SystemOfEquations(n) { // n is the number of variables in the system of equations
    signal input x[n]; // this is the solution to the system of equations
    signal input A[n][n]; // this is the coefficient matrix
    signal input b[n]; // this are the constants in the system of equations
    signal output out; // 1 for correct solution, 0 for incorrect solution

    // [bonus] insert your code here
    component matrixMul = matMul(n,n,1);

    for (var i=0; i<n; i++) {
        for (var j=0; j<n; j++) {
            matrixMul.a[i][j] <== A[i][j];
        }

        matrixMul.b[i][0] <== x[i];
    }

    component isEqual1 = IsEqual();
    component isEqual2 = IsEqual();
    component isEqual3 = IsEqual();

    isEqual1.in[0] <== matrixMul.out[0][0];
    isEqual1.in[1] <== b[0];

    isEqual2.in[0] <== matrixMul.out[1][0];
    isEqual2.in[1] <== b[1];

    isEqual3.in[0] <== matrixMul.out[2][0];
    isEqual3.in[1] <== b[2];

    component and1 = AND();
    component and2 = AND();

    and1.a <== isEqual1.out;
    and1.b <== isEqual2.out;

    and2.a <== isEqual3.out;
    and2.b <== and1.out;

    out <== and2.out;
}

component main {public [A, b]} = SystemOfEquations(3);