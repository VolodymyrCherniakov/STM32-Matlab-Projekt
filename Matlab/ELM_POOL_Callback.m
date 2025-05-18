function  ELM_POOL_Callback(app, iD, nData, xData)
    try   
        switch iD
            case 40001
                disp(char(xData(1:end-1)'))
                %app.AddKonsola(char(xData(1:end-1)));
                app.AddConsole(char(xData(1:end-1)));
                %app.AddKonsola("Cas: " + num2str(xData(end) / 216000 + " ms"))
                app.AddConsole("Cas: " + num2str(xData(end) / 216000 + " ms"))
            case 40002
                figure(1);
                hold on
                plot(xData(1:end-1)+0.1);
                %app.AddKonsola(num2str(xData(1:end-1)));
                app.AddConsole(num2str(xData(1:end-1)));
                %app.AddKonsola("Cas: " + num2str(xData(end) / 216000 + " ms" )) %milisekundy: 1 tik = 0.2 ms
                app.AddConsole("Cas: " + num2str(xData(end) / 216000 + " ms" ))
            case 50002
                %app.AddKonsola(num2str(xData(end-1:-1:1)));
                app.AddConsole(num2str(xData(end-1:-1:1)));
                %app.AddKonsola("Cas: " + num2str(xData(end) / 216000 + " ms"))
                app.AddConsole("Cas: " + num2str(xData(end) / 216000 + " ms"))
            case 10003
                %app.EditField_B1.Value= double(xData);
                %app.AddKonsola("Doba stisku B1: " + num2str(xData));
                app.AddConsole("Doba stisku B1: " + num2str(xData));
            case 10004
                app.EditField_ADC.Value = double(xData);
            otherwise
        end
    catch ME
        disp(ME.message)   %             rethrow(ME)
    end
end