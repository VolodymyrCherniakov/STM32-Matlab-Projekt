function [iD, nData, xData] = readDataSTM32(s)
    try
        if s == 0
            return;
        end
        iD = 0; nData = 0; xData = 0;
        
        % Pokud je k dispozici dostatek dat, pokračuj
        if s.NumBytesAvailable > 3
            % Načteme identifikátor a počet dat
            iD = read(s, 1, "uint16");
            nData = read(s, 1, "uint16");
            
            if nData == 0
                return; % Pokud není žádná data, opustíme funkci
            end

            % Ujistíme se, že jsou všechny požadované bajty k dispozici
            if isReady(s, nData * 4)
                % Načteme data v závislosti na identifikátoru
                if iD > 2^15
                    xData = read(s, nData, "single"); % Načteme jako single
                else
                    xData = uint32(read(s, nData, "uint32")); % Načteme jako uint32
                end
            end
        end
    catch ME
        disp(ME.message); % Vypíše chybu, pokud dojde k výjimce
    end
end

% Funkce pro kontrolu, zda jsou všechny požadované bajty k dispozici
function statusIsReady = isReady(s, nX)
    timeout = 5; % Maximální čas čekání v sekundách
    startTime = tic;
    
    while toc(startTime) < timeout
        pause(0.01); % Pauza pro uvolnění procesoru
        if s.NumBytesAvailable >= nX
            statusIsReady = 1;
            return;
        end
    end
    
    % Pokud timeout uplyne, vrátí 0
    statusIsReady = 0;
end

