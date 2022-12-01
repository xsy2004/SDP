% BlackJack

clc
clear


gameLogic()

function gameLogic()
    init = simpleGameEngine('retro_cards.png',16,16,10,[0,100,0]);
    % gamerStatus = 0;
    % defint variable
    gameStatus = 0;
    count = 0;
    card_sprites = 21:72;
    

    board_display(:,:) = 1 * ones(5,5);

    drawScene(init, board_display)
    text(60, 300, "Welcome Play Blackjack Game", 'FontSize', 25,'Color','white')
    % Start button
    annotation('textbox', [0.3 0.2 0.1 0.1], 'String', 'Start','FontSize', 28, 'FontWeight','bold', 'Color', [0.3010 0.7450 0.9330],'LineWidth',2, Margin=1, HorizontalAlignment='center')
    % Exit Button
    annotation('textbox', [0.6 0.2 0.1 0.1], 'String', 'Exit','FontSize', 28, 'FontWeight','bold', 'Color', [0.3010 0.7450 0.9330],'LineWidth',2, Margin=1, HorizontalAlignment='center')

    [x,y] = getMouseInput(init);
    if isequal([x y],[5 2]) == 1 || isequal([x y],[4 2]) == 1 || isequal([x y],[5 3]) == 1
        gameStatus = 1;
        clf
    else
        close all
    end

    if gameStatus == 1
        [sum_ai, sum_user, board_display] = reDeal(init, card_sprites);
        string_user = sprintf("Your score %.f", sum_user);
        text_user = text(80, 400, string_user, 'FontSize', 20);
        
    
        string_ai = sprintf("AI score %.f", sum_ai(1));
        text_ai = text(480, 400, string_ai, 'FontSize', 20);
    
        % make some text button
        %text(200, 530, "Hit", 'FontSize', 25, 'FontWeight','bold', 'Color', [0.3010 0.7450 0.9330])
        %text(500, 530, "Stand", 'FontSize', 25, 'FontWeight','bold', 'Color', [0.3010 0.7450 0.9330])
        credit = 1000;
        string_credit = sprintf("Availiable Credit %.f", credit);
        text_credit = text(200, 300, string_credit, 'FontSize', 20);
        % Hit button
        annotation('textbox', [0.3 0.3 0.1 0.1], 'String', 'Hit','FontSize', 23, 'FontWeight','bold', 'Color', [0.3010 0.7450 0.9330],'LineWidth',2, Margin=1, HorizontalAlignment='center')
    
        % Stand Button
        annotation('textbox', [0.6 0.3 0.1 0.1], 'String', 'Stand','FontSize', 23, 'FontWeight','bold', 'Color', [0.3010 0.7450 0.9330],'LineWidth',2, Margin=1, HorizontalAlignment='center')
    
        % Split Button
        visible = 'off';
        annotation('textbox', [0.5 0.3 0.1 0.1], 'String', 'Split','FontSize', 23, 'FontWeight','bold', 'Color', [0.3010 0.7450 0.9330],'LineWidth',2, Margin=1, HorizontalAlignment='center', Visible=visible)
        
        
        
        while credit >= 0
            deal = board_display(5,:)
            if count <= 5
                nullPosition = find(deal == 2);
                count = count + 1;
                [x,y] = getMouseInput(init);
                % board_display(x,y) = 11;
    
                % Hit action
                if isequal([x y],[4 2]) == 1
                    card = getRandomCard(1);
                    board_display(5,nullPosition(count)) = card_sprites(card);
                    sum_user = sum_user + calculateSum(card);
                    text_user.String = sprintf("Your score %.f", sum_user);
    
                    
    %                 text_ai = sprintf("AI score %.f", sum_ai(1));
    %                 text(480, 400, text_ai, 'FontSize', 20)
                    if sum_user > 21
                        credit = credit - 100;
                        string_credit = sprintf("Availiable Credit %.f", credit);
                        text_credit.String = string_credit;
                        
                        [sum_ai, sum_user, board_display] = reDeal(init, card_sprites);

                        sum_user = 0;
                        text_user.String = sprintf("Your score %.f", sum_user);
                    end
                        
                end
            end
            count = 0;

            % Stand action
            if isequal([x y],[4 4]) == 1
                gameStatus = 1;
            end
            drawScene(init, board_display)
            
        end
    end
    
    

    
end

function result = calculateSum(x)
    for index = 1:length(x)
        if x(index) > 13 && x(index) <= 13 * 2
            x(index) = x(index) - 13;
        end
        if x(index) > 13 * 2 && x(index) <= 13 * 3
            x(index) = x(index) - 13 * 2;
        end
        if x(index) > 13 * 3 && x(index) <= 13 * 4
            x(index) = x(index) - 13 * 3;
        end
        if ismember(x(index),[11 12 13]) == 1
            x(index) = 10;
        end
    end
    result = x;
end

function result =  getRandomCard(x)
    random_choose = randperm(52);
    % initial ai deal
    result = random_choose(1:x);
end

function [sum_ai, sum_user, result] = reDeal(init, card_sprites)
        % make a empty board
        board_display(:,:) = 2 * ones(5,5);
        board_display(2:4,:) = 1;
    
    
        % initial ai deal
        pickup_ai = getRandomCard(2);
        board_display(1,2:3) = [card_sprites(pickup_ai(1)) 11];
        sum_ai = calculateSum(pickup_ai());

        % initial user deal
        pickup_user = getRandomCard(2);
        board_display(5,2:3) = card_sprites(pickup_user());
        sum_user = sum(calculateSum(pickup_user()));

        result = board_display;
        drawScene(init, board_display)
        
end

