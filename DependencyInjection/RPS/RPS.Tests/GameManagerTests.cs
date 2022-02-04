using NUnit.Framework;
using RPS.BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RPS.Tests
{
    [TestFixture]
    public class GameManagerTests
    {
        [Test]
        public void RockTests()
        {
            GameManager gm = new GameManager(new AlwaysRock());

            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Scissors).Player1Result);
        }

        [Test]
        public void PaperTests()
        {
            GameManager gm = new GameManager(new AlwaysPaper());

            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Scissors).Player1Result);
        }

        [Test]
        public void ScissorsTests()
        {
            GameManager gm = new GameManager(new AlwaysScissors());

            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Scissors).Player1Result);
        }

        [Test]
        public void AllTheTests()
        {
            GameManager2 gm = new GameManager2();
            // property injection
            gm.ChoiceBehavior = new AlwaysScissors();

            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Scissors).Player1Result);

            gm.ChoiceBehavior = new AlwaysPaper();

            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Scissors).Player1Result);

            gm.ChoiceBehavior = new AlwaysRock();

            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Scissors).Player1Result);
        }

        [Test]
        public void AllTheTests2()
        {
            GameManager3 gm = new GameManager3();
            // method injection
            gm.SetChoiceBehavior(new AlwaysScissors());

            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Scissors).Player1Result);

            gm.SetChoiceBehavior(new AlwaysPaper());

            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Scissors).Player1Result);

            gm.SetChoiceBehavior(new AlwaysRock());

            Assert.AreEqual(GameResult.Tie, gm.PlayRound(Choice.Rock).Player1Result);
            Assert.AreEqual(GameResult.Win, gm.PlayRound(Choice.Paper).Player1Result);
            Assert.AreEqual(GameResult.Loss, gm.PlayRound(Choice.Scissors).Player1Result);
        }

    }
}
