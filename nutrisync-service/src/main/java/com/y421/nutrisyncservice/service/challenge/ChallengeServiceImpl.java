package com.y421.nutrisyncservice.service.challenge;

import com.y421.nutrisyncservice.entity.challenge.Challenge;
import com.y421.nutrisyncservice.entity.challenge.ChallengeDailyProgress;
import com.y421.nutrisyncservice.entity.challenge.ChallengeStatus;
import com.y421.nutrisyncservice.entity.challenge.UserChallenge;
import com.y421.nutrisyncservice.entity.nutrisyncUser.NutrisyncUser;
import com.y421.nutrisyncservice.repository.challenge.ChallengeProgressRepository;
import com.y421.nutrisyncservice.repository.challenge.ChallengeRepository;
import com.y421.nutrisyncservice.repository.challenge.UserChallengeRepository;
import com.y421.nutrisyncservice.repository.nutrisyncUser.NutrisyncUserRepository;
import com.y421.nutrisyncservice.request.challenge.JoinChallengeDTO;
import com.y421.nutrisyncservice.request.challenge.LogProgressDTO;
import com.y421.nutrisyncservice.response.challenge.ActiveChallengeDTO;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ChallengeServiceImpl implements ChallengeService {

    private final ChallengeRepository challengeRepository;
    private final UserChallengeRepository userChallengeRepository;
    private final ChallengeProgressRepository progressRepository;
    private final NutrisyncUserRepository userRepository;

    @Override
    public ResponseEntity<Object> getAllChallenges() {
        List<Challenge> challenges = challengeRepository.findAll();
        return new ResponseEntity<>(challenges, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> getAvailableChallenges(Long userId) {

        Optional<NutrisyncUser> userOpt = userRepository.findById(userId);

        if (userOpt.isEmpty()) {
            return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        }
        NutrisyncUser user = userOpt.get();

        List<Challenge> allChallenges = challengeRepository.findAll();

        // Only get ACTIVE challenges
        List<UserChallenge> activeChallenges =
                userChallengeRepository.findByUserAndStatus(user, ChallengeStatus.ACTIVE);

        Set<Long> activeChallengeIds = activeChallenges.stream()
                .map(uc -> uc.getChallenge().getChallengeId())
                .collect(Collectors.toSet());

        List<Challenge> available = allChallenges.stream()
                .filter(c -> !activeChallengeIds.contains(c.getChallengeId()))
                .toList();

        return new ResponseEntity<>(available, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> getActiveChallenges(Long userId) {

        Optional<NutrisyncUser> userOpt = userRepository.findById(userId);

        if (userOpt.isEmpty()) {
            return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        }

        List<UserChallenge> userChallenges =
                userChallengeRepository.findByUserAndStatus(userOpt.get(), ChallengeStatus.ACTIVE);

        List<ActiveChallengeDTO> response = new ArrayList<>();

        for (UserChallenge uc : userChallenges) {

            Challenge challenge = uc.getChallenge();

            int duration = challenge.getDurationDays();
            int completed = uc.getCompletedDays();
            int daysLeft = duration - completed;

            double percent = ((double) completed / duration) * 100;

            ActiveChallengeDTO dto = new ActiveChallengeDTO(
                    uc.getUserChallengeId(),
                    challenge.getName(),
                    challenge.getDescription(),
                    duration,
                    completed,
                    daysLeft,
                    percent,
                    challenge.getPointsReward()
            );

            response.add(dto);
        }
        return new ResponseEntity<>(response, HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> getChallengeDetails(Long challengeId) {

        Optional<Challenge> challenge = challengeRepository.findById(challengeId);

        if (challenge.isEmpty()) {
            return new ResponseEntity<>("Challenge not found", HttpStatus.NOT_FOUND);
        }

        return new ResponseEntity<>(challenge.get(), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> getUserPoints(Long userId) {

        Optional<NutrisyncUser> user = userRepository.findById(userId);

        if (user.isEmpty()) {
            return new ResponseEntity<>("User not found", HttpStatus.NOT_FOUND);
        }

        return new ResponseEntity<>(user.get().getPoints(), HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> joinChallenge(JoinChallengeDTO dto) {

        Optional<NutrisyncUser> userOpt = userRepository.findById(dto.getUserId());
        Optional<Challenge> challengeOpt = challengeRepository.findById(dto.getChallengeId());

        if (userOpt.isEmpty() || challengeOpt.isEmpty()) {
            return new ResponseEntity<>("User or Challenge not found", HttpStatus.NOT_FOUND);
        }

        NutrisyncUser user = userOpt.get();
        Challenge challenge = challengeOpt.get();

        Integer attempts = userChallengeRepository.countByUserAndChallenge(user, challenge);

        UserChallenge uc = new UserChallenge();
        uc.setUser(user);
        uc.setChallenge(challenge);
        uc.setStartDate(LocalDate.now());
        uc.setEndDate(LocalDate.now().plusDays(challenge.getDurationDays()));
        uc.setCompletedDays(0);
        uc.setAttemptNumber(attempts + 1);
        uc.setStatus(ChallengeStatus.ACTIVE);

        userChallengeRepository.save(uc);

        return new ResponseEntity<>("Challenge Joined", HttpStatus.OK);
    }

    @Override
    public ResponseEntity<Object> logProgress(LogProgressDTO dto) {

        Optional<UserChallenge> ucOpt =
                userChallengeRepository.findByUserChallengeIdAndStatus(dto.getUserChallengeId(), ChallengeStatus.ACTIVE);

        if (ucOpt.isEmpty()) {
            return new ResponseEntity<>("Active challenge not found", HttpStatus.NOT_FOUND);
        }

        UserChallenge uc = ucOpt.get();

        int nextDay = uc.getCompletedDays() + 1;

        Boolean alreadyLogged =
                progressRepository.existsByUserChallengeAndDayNumber(uc, nextDay);

        if (alreadyLogged) {
            return new ResponseEntity<>("Progress already logged for today", HttpStatus.CONFLICT);
        }

        ChallengeDailyProgress progress = new ChallengeDailyProgress();
        progress.setUserChallenge(uc);
        progress.setDayNumber(nextDay);
        progress.setLogDate(LocalDate.now());
        progress.setCompleted(true);

        progressRepository.save(progress);

        uc.setCompletedDays(nextDay);

        if (nextDay == uc.getChallenge().getDurationDays()) {

            uc.setStatus(ChallengeStatus.COMPLETED);

            NutrisyncUser user = uc.getUser();
            user.setPoints(user.getPoints() + uc.getChallenge().getPointsReward());

            userRepository.save(user);
        }

        userChallengeRepository.save(uc);

        return new ResponseEntity<>("Progress Logged", HttpStatus.OK);
    }
}
