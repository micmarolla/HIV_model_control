% Model ODE
function x_dot = modelODE(x, u, p)
    x_dot = zeros(3,1);
    x_dot(1) = p(1)*(p(7) - x(1)) - p(2)*x(1)*x(3);
    x_dot(2) = p(3)*(p(8) - x(2)) + p(4)*x(2)*x(3);
    x_dot(3) = x(3) * (p(5)*x(1) - p(6)*x(2)) - u;
end