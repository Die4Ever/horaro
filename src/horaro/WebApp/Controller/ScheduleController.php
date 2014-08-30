<?php
/*
 * Copyright (c) 2014, Sgt. Kabukiman, https://bitbucket.org/sgt-kabukiman/
 *
 * This file is released under the terms of the MIT license. You can find the
 * complete text in the attached LICENSE file or online at:
 *
 * http://www.opensource.org/licenses/mit-license.php
 */

namespace horaro\WebApp\Controller;

use horaro\Library\Entity\Event;
use horaro\Library\Entity\Schedule;
use horaro\WebApp\Exception as Ex;
use horaro\WebApp\Validator\ScheduleValidator;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;

class ScheduleController extends BaseController {
	public function detailAction(Request $request) {
		$schedule  = $this->getRequestedSchedule($request);
		$items     = [];
		$columnIDs = [];

		foreach ($schedule->getItems() as $item) {
			$items[] = [
				$item->getId(),
				$item->getLengthInSeconds(),
				$item->getExtra()
			];
		}

		foreach ($schedule->getColumns() as $column) {
			$columnIDs[] = $column->getId();
		}

		return $this->render('schedule/detail.twig', ['schedule' => $schedule, 'items' => $items ?: null, 'columns' => $columnIDs]);
	}

	public function newAction(Request $request) {
		$event = $this->getRequestedEvent($request);

		return $this->renderForm($event);
	}

	public function createAction(Request $request) {
		$event     = $this->getRequestedEvent($request);
		$validator = new ScheduleValidator($this->getRepository('Schedule'));
		$result    = $validator->validate([
			'name'       => $request->request->get('name'),
			'slug'       => $request->request->get('slug'),
			'timezone'   => $request->request->get('timezone'),
			'twitch'     => $request->request->get('twitch'),
			'start_date' => $request->request->get('start_date'),
			'start_time' => $request->request->get('start_time')
		], $event);

		if ($result['_errors']) {
			return $this->renderForm($event, null, $result);
		}

		// create schedule

		$user     = $this->getCurrentUser();
		$schedule = new Schedule();

		$schedule
			->setEvent($event)
			->setName($result['name']['filtered'])
			->setSlug($result['slug']['filtered'])
			->setTimezone($result['timezone']['filtered'])
			->setUpdatedAt(new \DateTime('now UTC'))
			->setStart($result['start']['filtered'])
//			->setTwitch($result['twitch']['filtered'])
		;

		$em = $this->getEntityManager();
		$em->persist($schedule);
		$em->flush();

		// done

		return $this->redirect('/-/schedules/'.$schedule->getId());
	}

	public function editAction(Request $request) {
		$schedule = $this->getRequestedSchedule($request);

		return $this->renderForm($schedule->getEvent(), $schedule, null);
	}

	public function updateAction(Request $request) {
		$schedule  = $this->getRequestedSchedule($request);
		$event     = $schedule->getEvent();
		$validator = new ScheduleValidator($this->getRepository('Schedule'));
		$result    = $validator->validate([
			'name'       => $request->request->get('name'),
			'slug'       => $request->request->get('slug'),
			'timezone'   => $request->request->get('timezone'),
			'twitch'     => $request->request->get('twitch'),
			'start_date' => $request->request->get('start_date'),
			'start_time' => $request->request->get('start_time')
		], $event, $schedule);

		if ($result['_errors']) {
			return $this->renderForm($event, $schedule, $result);
		}

		// update

		$schedule
			->setName($result['name']['filtered'])
			->setSlug($result['slug']['filtered'])
			->setTimezone($result['timezone']['filtered'])
			->setUpdatedAt(new \DateTime('now UTC'))
			->setStart($result['start']['filtered'])
//			->setTwitch($result['twitch']['filtered'])
		;

		$em = $this->getEntityManager();
		$em->persist($schedule);
		$em->flush();

		// done

		return $this->redirect('/-/schedules/'.$schedule->getId());
	}

	public function confirmationAction(Request $request) {
		$schedule = $this->getRequestedSchedule($request);

		return $this->render('schedule/confirmation.twig', ['schedule' => $schedule]);
	}

	public function deleteAction(Request $request) {
		$schedule = $this->getRequestedSchedule($request);
		$eventID  = $schedule->getEvent()->getId();
		$em       = $this->getEntityManager();

		$em->remove($schedule);
		$em->flush();

		return $this->redirect('/-/events/'.$eventID);
	}

	protected function renderForm(Event $event, Schedule $schedule = null, $result = null) {
		$timezones = \DateTimeZone::listIdentifiers();

		return $this->render('schedule/form.twig', [
			'event'     => $event,
			'timezones' => $timezones,
			'schedule'  => $schedule,
			'result'    => $result
		]);
	}
}