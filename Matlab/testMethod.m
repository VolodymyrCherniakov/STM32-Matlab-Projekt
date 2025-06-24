function testMethod(app)
    % Test method for sending arrays of different lengths to STM32 and plotting transmission times
    try
        if isempty(app.s) || ~isvalid(app.s)
            app.AddConsole('Error: Serial port not connected.');
            return;
        end

        app.AddConsole('Starting test method...');

        % Pole pro ukládání délek polí a časů přenosu
        array_lengths = 200:200:10000;
        transmission_times = zeros(size(array_lengths)); % Časy přenosu v sekundách
        idx = 1; % Index pro ukládání časů

        for i = array_lengths
            app.arrSize = i;
            app.AddConsole(sprintf('Sending array of size %d...', i));

            % Odeslání dat na STM32
            ELM_POOL_Extern_Button_ID(app, 50002);

            % Čekání na odpověď od STM32 s timeoutem
            startTime = tic;
            while toc(startTime) < 5
                [iD, nData, xData] = readDataSTM32(app.s);
                if iD ~= 0 && nData ~= 0
                    break;
                end
                pause(1); % Krátká pauza pro uvolnění procesoru
            end

            % Kontrola odpovědi
            if iD == 0 || nData == 0
                transmission_times(idx) = NaN; % Označit jako chybějící data
            else
                if iD == 50002 && nData == i+1
                    % Výpočet času přenosu z xData(end) / 216000 (předpokládám, že je v cyklech při 216 MHz)
                    transmission_time = xData(end); % Čas v tikech
                    transmission_times(idx) = transmission_time;

                    app.AddConsole(sprintf('Received: ID=%d, nData=%d, Transmission Time: %.6f s', ...
                        iD, nData, transmission_time));
                    app.Data_Info_Label.Text = sprintf('ID: %d  nData: %d  Time: %.6f s', iD, nData, transmission_time);
                else
                    app.AddConsole(sprintf('Mismatch: Expected ID=50002, nData=%d, got ID=%d, nData=%d', ...
                        i+1, iD, nData));
                    transmission_times(idx) = NaN; % Označit jako chybějící data
                end
            end

            idx = idx + 1;
            pause(0.1); % Krátká pauza mezi odesláním dalšího pole
        end

        app.AddConsole('Test method completed.');

        figure('Name', 'Graf měření času', 'NumberTitle', 'off');
        plot(array_lengths, transmission_times, '-', 'LineWidth', 2); % Plná čára, tloušťka 2
        xlabel('nData');
        ylabel('t (čas)');
        title('Graf měření času');
        grid on;
        
        % Zobrazení informace o grafu v UI
        app.AddConsole('Graph of Transmission Time vs Array Length has been created.');
        transmission_times
        array_lengths
    catch ME
        app.AddConsole(['Error: ' ME.message]);
    end
end