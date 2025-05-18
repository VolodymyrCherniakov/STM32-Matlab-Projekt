function ELM_POOL_Extern_Button_ID(app, ID)
try
    if nargin<2
        ID=10001;
        app=app_ZERO;
    end
    switch ID
        case 40001
            writeDataSTM32(app.s, 40001, 0, 0);
        case 40002
            fs = 8000;
            f = 500;
            n = 10000;
            t = 0:1/fs:n/fs-1/fs;
            x = sin(2*pi*f*t);
            plot(x);
            writeDataSTM32(app.s, 40002, n, x);
        case 50002
            n = app.arrSize;
            x = (1:n);
            writeDataSTM32(app.s, 50002, n, x);
        otherwise
    end
catch ME
    disp(ME.message)   %             rethrow(ME)
end 
end

